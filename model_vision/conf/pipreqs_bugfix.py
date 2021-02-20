with open("./conf/requirements.txt","r") as f:
  lines = f.readlines()
  fixed_lines = []
  for line in lines:
    fixed_lines.append(line.replace("_","-"))

with open("./conf/requirements.txt","w") as f:
  for line in fixed_lines:
    f.write(line)


