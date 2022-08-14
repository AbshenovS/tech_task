import json
import xml.etree.ElementTree as ET


def transform_json_to_xml(request_body: bytes) -> str:
    """Transform json to xml"""
    record = json.loads(request_body)
    root = ET.Element('employee')
    ET.SubElement(root, 'fullname').text = record['fullname']
    ET.SubElement(root, 'skills').text = str(record['skills'])

    characteristic_el = ET.SubElement(root, 'characteristics')
    characteristics = record['characteristics']
    for characteristic in characteristics:
        ET.SubElement(characteristic_el, characteristic).text = str(characteristics[characteristic])

    experience_all = ET.SubElement(root, 'experiences')
    for exp in record['experience']:
        experience_el = ET.SubElement(experience_all, 'experience')
        ET.SubElement(experience_el, 'position').text = exp['position'] if 'position' in exp else ''
        ET.SubElement(experience_el, 'workplace').text = exp['workplace'] if 'workplace' in exp else ''
        ET.SubElement(experience_el, 'salary').text = str(exp['salary']) if 'salary' in exp else ''
        ET.SubElement(experience_el, 'id_card').text = str(exp['id_card']) if 'id_card' in exp else ''
        ET.SubElement(experience_el, 'Country').text = exp['Country'] if 'Country' in exp else ''

    return ET.tostring(root).decode()
