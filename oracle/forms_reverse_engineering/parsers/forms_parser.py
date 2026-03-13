import xml.etree.ElementTree as ET


class FormsParser:

    def __init__(self, xml_file):

        self.tree = ET.parse(xml_file)

        self.root = self.tree.getroot()

    def get_blocks(self):

        blocks = []

        for elem in self.root.iter():

            if elem.tag.lower().endswith("block"):

                name = elem.attrib.get("Name") or elem.attrib.get("name")

                if name:
                    blocks.append(name)

        return blocks


    def get_items(self):

        items = []

        for elem in self.root.iter():

            if elem.tag.lower().endswith("item"):

                name = elem.attrib.get("Name") or elem.attrib.get("name")

                if name:
                    items.append(name)

        return items


    def get_triggers(self):

        triggers = []

        for elem in self.root.iter():

            if elem.tag.lower().endswith("trigger"):

                code = ""

                if "TriggerText" in elem.attrib:

                    code += elem.attrib["TriggerText"]

                if elem.text:

                    code += elem.text

                triggers.append(code)

        return triggers