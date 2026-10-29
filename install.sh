#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
skills_dir="$script_dir/my-skills"
target_root="${HOME}/.agents/skills"

copy_skill() {
	local skill_dir="$1"
	local skill_name
	skill_name="$(basename "$skill_dir")"
	local source_file=""

	if [[ -f "$skill_dir/${skill_name}.md" ]]; then
		source_file="$skill_dir/${skill_name}.md"
	elif [[ -f "$skill_dir/SKILL.md" ]]; then
		source_file="$skill_dir/SKILL.md"
	else
		return 0
	fi

	local target_dir="$target_root/$skill_name"
	mkdir -p "$target_dir"
	cp "$source_file" "$target_dir/${skill_name}.md"
}

if [[ -d "$skills_dir" ]]; then
	shopt -s nullglob
	copied=0
	for skill_dir in "$skills_dir"/*; do
		[[ -d "$skill_dir" ]] || continue
		copy_skill "$skill_dir"
		copied=$((copied + 1))
	done
	shopt -u nullglob

	if (( copied > 0 )); then
		rm -rf "$skills_dir"
	fi
fi
