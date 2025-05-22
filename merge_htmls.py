from pathlib import Path

# Root output directory
html_root = Path("output")
html_files = sorted(html_root.rglob("*.html"))  # Recursively find all HTMLs

# Build tree structure: { folder_path: [html_files] }
from collections import defaultdict

folder_tree = defaultdict(list)
for html_file in html_files:
    relative_path = html_file.relative_to(html_root)
    folder_path = relative_path.parent
    folder_tree[folder_path].append(relative_path)

# Recursive function to render folder structure
def render_folder(folder_path):
    html = '<ul>'
    subfolders = set()
    for file in folder_tree.get(folder_path, []):
        file_id = str(file).replace("/", "_").replace("\\", "_").replace(".", "_")
        html += f'<li><a href="#" onclick="openTab(\'{file_id}\')">{file.name}</a></li>'

    # Detect subfolders
    for path in folder_tree:
        if path.parent == folder_path:
            subfolders.add(path)

    for subfolder in sorted(subfolders):
        html += f'<li><span class="folder" onclick="toggleFolder(this)">{subfolder.name}</span>'
        html += render_folder(subfolder)
        html += '</li>'

    html += '</ul>'
    return html

# Generate tab contents (hidden divs with HTML content)
tab_contents = []
for html_file in html_files:
    relative_path = html_file.relative_to(html_root)
    file_id = str(relative_path).replace("/", "_").replace("\\", "_").replace(".", "_")
    content = html_file.read_text(encoding='utf-8', errors='ignore')
    tab_contents.append(f'''
    <div id="{file_id}" class="tabcontent" style="display:none">
        <h2>{relative_path}</h2>
        {content}
    </div>
    ''')

# Final output HTML
output_html = f"""
<html>
<head>
<style>
ul {{ list-style-type: none; margin-left: 20px; padding-left: 10px; }}
.folder {{ cursor: pointer; font-weight: bold; }}
.folder::before {{ content: "▶ "; display: inline-block; transition: transform 0.2s; }}
.folder.open::before {{ transform: rotate(90deg); }}
.tabcontent {{ display: none; padding: 10px; border: 1px solid #ccc; margin-top: 10px; }}
</style>
<script>
function toggleFolder(element) {{
    element.classList.toggle('open');
    const nextUl = element.nextElementSibling;
    if (nextUl && nextUl.tagName === 'UL') {{
        nextUl.style.display = (nextUl.style.display === 'none') ? 'block' : 'none';
    }}
}}
function openTab(tabId) {{
    document.querySelectorAll('.tabcontent').forEach(el => el.style.display = 'none');
    document.getElementById(tabId).style.display = 'block';
}}
</script>
</head>
<body>
<h1>HTML Folder Navigator</h1>
<div>
    {render_folder(Path('.'))}
</div>
<div>
    {' '.join(tab_contents)}
</div>
</body>
</html>
"""

# Write output index.html at the root of output/
index_path = html_root / "index.html"
index_path.write_text(output_html, encoding="utf-8")
print(f"Generated index with {len(html_files)} HTML files at {index_path}")
