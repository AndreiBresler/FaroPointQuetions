def unique_names(strings: List[str]) -> int:
  names = [name.strip().lower() for name_string in strings for name in name_string.split(';')]
  unique_names = set(names)
  return len(unique_names)