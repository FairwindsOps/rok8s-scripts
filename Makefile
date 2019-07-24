docs-index:
	cat README.md \
	| sed -E 's/\[(.*)\]\(([^\/]*\.md)\)/[\1](https:\/\/github.com\/FairwindsOps\/rok8s-scripts\/tree\/master\/\2)/g' \
	| sed -E 's/\[(.*)\]\(\/*docs\/(.*)\)/[\1](\2)/g' \
	| sed -E 's/\[(.*)\]\((\/.*)\)/[\1](https:\/\/github.com\/FairwindsOps\/rok8s-scripts\/tree\/master\2)/g' \
	> docs/index.md
orb-validate:
	circleci config pack orb/ > orb.yml
	circleci orb validate orb.yml
