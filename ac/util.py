from . import namespaces

def normalize_title(title):
	if title == None or len(title) == 0:
		return title
	else:
		title = title[0].capitalize() + title[1:]
		return title.replace(" ", "_")

NAMESPACES = {}
for lang, namespace_ids in namespaces.NS.iteritems():
	
	names = {}
	for ns in namespace_ids.values():
		names[normalize_title(ns.get('canonical'))] = ns['id']
		if '*' in ns:
			names[ns['*']] = ns['id']
			
		
	
	NAMESPACES[lang] = names

def parse_page_name(page_name, lang='en'):
	namespaces = NAMESPACES[lang]
	page_name = normalize_title(page_name)
	
	parts = page_name.split(":", 1)
	if len(parts) == 1:
		ns = 0
		title = page_name
	else:
		ns_name, sub_title = parts
		
		if ns_name in namespaces:
			ns = namespaces[ns_name]
			title = normalize_title(sub_title)
		else:
			ns = 0
			title = page_name
		
	
	return ns, title
