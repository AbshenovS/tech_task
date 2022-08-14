import time

import requests
from bs4 import BeautifulSoup
import pandas as pd
from concurrent.futures import ThreadPoolExecutor
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry


requests.packages.urllib3.disable_warnings()


class Parser:

    def __init__(self):
        self.requests_session = requests.Session()
        self.requests_session.verify = False
        self.requests_session.headers.update({
            "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"
        })
        # retry_strategy = Retry(
        #     total=10,
        #     status_forcelist=[429],
        #     method_whitelist=['GET']
        # )
        # adapter = HTTPAdapter(max_retries=retry_strategy)
        # self.requests_session.mount("https://", adapter)

    def get_all_links(self):
        """Collect and return individual page links of all organizations"""
        main_url = 'https://www.goszakup.gov.kz/ru/registry/rqc?count_record=2000&page=1'
        response = self.requests_session.get(main_url)
        soup = BeautifulSoup(response.content, 'html5lib')
        table = soup.find('table', attrs={'class': 'table table-bordered table-hover'}).find('tbody')
        links = [tr.find('a')['href'] for tr in table.find_all('tr')]

        print(f'=== {len(links)} organizations information will be parsed ===')

        return links

    def get_info_of_organization(self, link: str) -> list:
        """Collect info for given organization"""
        retries = 5
        while retries:
            response = self.requests_session.get(link)
            soup = BeautifulSoup(response.content, 'html5lib')
            tables = soup.find_all('table', attrs={'class': 'table table-striped'})
            if len(tables) == 4:
                break
            # time.sleep(int(response.headers['Retry-After']))
            time.sleep(20)  # after experiments defined optimal sleep time as 20 seconds
            print('=== There is 429 Error, will try again ===')
            retries -= 1

        if retries == 0:
            raise ValueError('Cant avoid 429 Error')

        org_table, _, boss_table, contacts_table = tables

        org_info = [tr.find('td').text.strip() for tr in org_table.find('tbody').find_all('tr')]
        org_name, org_bin = org_info[7], org_info[4]

        boss_info = [tr.find('td').text.strip() for tr in boss_table.find('tbody').find_all('tr')]
        boss_name, boss_iin = boss_info[2], boss_info[0]

        address = contacts_table.find('tbody').find_all('tr')[1].find_all('td')[2].text.strip()

        return [org_name, org_bin, boss_name, boss_iin, address]

    def get_dataframe(self, threads_number: int = 10) -> pd.DataFrame:
        """Prepare DataFrame with information for all organizations"""
        all_links = self.get_all_links()

        info = []
        for link in all_links:
            info.append(self.get_info_of_organization(link))

        columns = ['Наименование организации', 'БИН организации', 'ФИО руководителя',
                   'ИИН руководителя', 'Полный адрес организации']
        df = pd.DataFrame(info, columns=columns)
        df.drop_duplicates(inplace=True)

        print(f'== Data collected for {df.shape[0]} unique organizations ==')
        # with ThreadPoolExecutor(max_workers=threads_number) as executor:
        #     result_list = executor.map(self.get_info_of_organization, all_links)

        return df

    def parse_and_save_file(self, path: str = None) -> None:
        """Parse information to DataFrame and save it as Excel file"""
        if path is None:
            path = './goszakupki_result.xlsx'

        goszakupki_df = self.get_dataframe()
        goszakupki_df.to_excel(path, index=False)
