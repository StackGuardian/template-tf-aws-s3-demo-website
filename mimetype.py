#This script can be utilized to get the mime types of the files inside the content directory.

import mimetypes
import os

def generate_mime_types(directory):
    mime_types = {}
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            mime_type, encoding = mimetypes.guess_type(file_path)
            if mime_type is not None:
                mime_types[file] = mime_type
    return mime_types

# Replace 'content' with the path to your directory containing the files
mime_types = generate_mime_types('content')

print('variable "mime_types" {')
print('  type = map(string)')
print('  default = {')
for file, mime_type in mime_types.items():
    print(f'    "{file}" = "{mime_type}",')
print('  }')
print('}')
