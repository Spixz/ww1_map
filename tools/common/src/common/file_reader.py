class FileReader:
    files: dict[str, str] = {}

    @classmethod
    def readFile(cls, filepath: str) -> str:
        if filepath in cls.files:
            return cls.files[filepath]
        with open(filepath, "r", encoding="utf-8") as file:
            cls.files[filepath] = file.read()
            return cls.files[filepath]