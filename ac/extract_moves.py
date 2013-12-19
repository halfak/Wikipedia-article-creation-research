import sys, argparse, re
from menagerie.formatting import tsv

from .util import parse_page_name

MOVE_COMMENT_RE = re.compile(r"^moved \[\[([^\]]+)\]\] to \[\[([^\]]+)\]\]:(.*)")

def utf8_replace(val):
	return unicode(val, "utf8", "replace")

def move_revision_reader(f):
	if not f.isatty():
		return tsv.Reader(f, types=[int, int, int, utf8_replace, int, 
		                            utf8_replace, utf8_replace, utf8_replace])

def main():
	parser = argparse.ArgumentParser(
		description="Extracts 'from' and 'to' from page move revisions.",
		conflict_handler="resolve"
	)
	parser.add_argument(
		'--move_revisions', 
		help="Move revisions to parse (defaults to stdin)",
		type=lambda path:move_revision_reader(open(path)),
		default=move_revision_reader(sys.stdin)
	)
	parser.add_argument(
		'--lang', 
		help="Language abbreviation to pull namespaces from",
		type=str,
		default="en"
	)
	
	args = parser.parse_args()
	
	run(args.move_revisions, args.lang)
	
	


def run(revisions, lang):
	
	writer = tsv.Writer(
		sys.stdout
	)
	"""
	headers=[
		'page_id',
		'page_namespace', 
		'page_title',
		'rev_id',
		'timestamp',
		'from_namespace',
		'from_title',
		'to_namespace',
		'to_title',
		'comment'
	]
	"""
	errors = 0
	
	for rev in revisions:
		
		match = MOVE_COMMENT_RE.match(rev.rev_comment)
		
		if match == None:
			errors += 1
			sys.stderr.write("Could not extract move from: " + rev.rev_comment + "\n")
		else:
			from_ns, from_title = parse_page_name(match.group(1), lang)
			to_ns, to_title = parse_page_name(match.group(2), lang)
			comment = match.group(3)
			
			writer.write(
				[
					rev.page_id,
					rev.page_namespace,
					rev.page_title,
					rev.rev_id,
					rev.rev_timestamp,
					from_ns,
					from_title,
					to_ns,
					to_title,
					comment
				]
			)
			
		
	#sys.stderr.write("\n")
