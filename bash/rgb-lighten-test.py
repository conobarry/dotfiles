import argparse, math
from typing import Optional

description = "A simple python script to produce several tints from a single rgb color."

parser = argparse.ArgumentParser(description=description)
# parser.add_argument("r", type=int)
# parser.add_argument("g", type=int)
# parser.add_argument("b", type=int)
parser.add_argument("-c", "--color", nargs=3, type=int)
parser.add_argument("-t", "--tint", type=float)
parser.add_argument("-a", "--args", type=list)
# parser.add_argument("-n", "--number", type=int, default=1)
# parser.add_argument("-o", "--output", type=argparse.FileType('w'))

args = parser.parse_args()
    
r = args.color[0]
g = args.color[1]
b = args.color[2]
tint_factor = args.tint_factor
number = args.number
# lighten(r, g, b)

reset="\033[0;00m"

def set_bg(r, g, b):
    return f"\033[48;2;{r};{g};{b}m"
    
def print_color(r, g, b):
    print(f"{set_bg(r, g, b)}{r:3} {g:3} {b:3}")

print_color(r, g, b)

for i in range(args.number - 1):
    new_r = math.floor(r + (255 - r) * tint_factor)
    new_g = math.floor(g + (255 - g) * tint_factor)
    new_b = math.floor(b + (255 - b) * tint_factor)
    r = new_r
    g = new_g
    b = new_b
    print_color(r, g, b)
    