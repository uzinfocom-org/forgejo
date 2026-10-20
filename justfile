default:
    @just --list

# Apply hlint suggestions for all (hlint --refactor takes one file at a time)
fix lint *paths="src test":
    find {{ paths }} -name '*.hs' -exec hlint --refactor --refactor-options="--inplace" {} \;
