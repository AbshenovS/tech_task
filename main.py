from web_parser import Parser
import time


def main():
    start = time.perf_counter()
    parser = Parser()
    parser.parse_and_save_file()
    print(f'== Script ended in {time.perf_counter() - start} seconds ==')


if __name__ == '__main__':
    main()
