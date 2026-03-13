import os


class PLSQLCollector:

    def collect(self, folder):

        files = []

        for root, dirs, fs in os.walk(folder):

            for f in fs:

                if f.endswith(".sql"):

                    files.append(os.path.join(root, f))

        return files