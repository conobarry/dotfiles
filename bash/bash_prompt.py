import argparse, math

description = "A simple python script to produce several tints from a single rgb color."

parser = argparse.ArgumentParser(description=description)
parser.add_argument("-c", "--color", nargs=3, type=int)
parser.add_argument("-b", "--black", nargs=3, type=int)
parser.add_argument("-w", "--white", nargs=3, type=int)
parser.add_argument("-t", "--tint", type=float, default=0.1)
parser.add_argument("-i", "--items", nargs="+")

args = parser.parse_args()

class Color:
    
    def __init__(self, r, g, b):
        self.r = r
        self.g = g
        self.b = b
        
    def to_shell(self):
        return f"{self.r};{self.g};{self.b}"

base_color = Color(args.color[0], args.color[1], args.color[2])
black = Color(args.black[0], args.black[1], args.black[2])
white = Color(args.white[0], args.white[1], args.white[2])

tint_factor = args.tint

reset = "\[\033[0;00m\]"
arrow = "\uE0B0"

# print(base_color.to_shell())

def rgb_to_prompt_color(r, g, b):
    return 

def set_bg(color):
    return f"\[\033[48;2;{color.r};{color.g};{color.b}m\]"

def set_fg(color):
    return f"\[\033[38;2;{color.r};{color.g};{color.b}m\]"
    
def lighten(color, tint):
    
    lighter_color = Color(0, 0, 0)
      
    lighter_color.r = math.floor(color.r + (255 - color.r) * tint)
    lighter_color.g = math.floor(color.g + (255 - color.g) * tint)
    lighter_color.b = math.floor(color.b + (255 - color.b) * tint)
        
    return lighter_color
    
prompt=""
bg_color = base_color
fg_color = white

for i in range(len(args.items)):
    
    item = args.items[i]
    
    next_bg_color = lighten(bg_color, tint_factor)
      
    prompt += set_fg(white)
    prompt += set_bg(bg_color)
    prompt += f" {item} "     
    prompt += set_fg(bg_color)
    
    if (i == len(args.items) - 1):
        prompt += set_bg(white)
    else:
        prompt += set_bg(next_bg_color)
        
    prompt += arrow
    
    bg_color = next_bg_color
    
prompt += f"{reset} "

print(prompt)


