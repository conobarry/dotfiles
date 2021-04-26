import argparse, yaml

description = ""
parser = argparse.ArgumentParser(description=description)
parser.add_argument("-v", "--verbose", help="verbose output", action="store_true")
parser.add_argument("config", help="config file to use", type=argparse.FileType())

args = parser.parse_args()

links = yaml.safe_load(open(''))
