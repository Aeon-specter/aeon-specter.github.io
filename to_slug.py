import sys
from pypinyin import lazy_pinyin
import re

def to_slug(text):
    pinyin_list = lazy_pinyin(text)
    slug = "-".join(pinyin_list)
    slug = re.sub(r'[^a-z0-9\-]', '', slug.lower())
    return slug

if __name__ == "__main__":
    text = sys.argv[1]
    print(to_slug(text))
