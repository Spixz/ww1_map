from tempfile import TemporaryDirectory


class TmpDir:
    tmp_folders: list[TemporaryDirectory] = []

    @classmethod
    def createTempFolder(cls):
        tmp_folder = TemporaryDirectory()
        cls.tmp_folders.append(tmp_folder)
        return tmp_folder.name

    @classmethod
    def dispose(cls):
        for folder in cls.tmp_folders:
            folder.cleanup()
