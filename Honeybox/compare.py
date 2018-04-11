# URL files list comparasion
# Results in saving differences/new URLs on the new file "file.txt"
# First run requires existing empty file called oldfile.txt to get all new URLs tested by Thug

try:
        with open('file.txt', 'r') as file1:
                with open('oldfile.txt', 'r') as file2:
                        diffs = set(file1).difference(file2)

        diffs.discard('\n')

        with open('urls.txt', 'a') as file_out:
                for line in diffs:
                        file_out.write(line)

except:
        with open("file.txt") as file1:
                with open("urls.txt", "w") as file2:
                        line = file1.readline()
                        file2.write(line)
