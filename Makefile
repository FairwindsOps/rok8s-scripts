docs-index:
	cat README.md \
	| sed 's/\[\(.*\)\](\(\w\+\.md\))/[\1](https:\/\/github.com\/reactiveops\/rok8s-scripts\/tree\/master\/\2)/g' \
	| sed 's/\[\(.*\)\](\/\?docs\/\(.*\))/[\1](\2)/g' \
	| sed 's/\[\(.*\)\](\(\/.*\))/[\1](https:\/\/github.com\/reactiveops\/rok8s-scripts\/tree\/master\2)/g' \
	> docs/index.md
