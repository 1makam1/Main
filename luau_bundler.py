import os

MODULES_PATH = "Apex-Universal-Script"
INIT_PATH = MODULES_PATH + "/Init.luau"
OUTPUT_PATH = "realease/Init.luau"
LINES = ["local __MODULES = {}\n\n--=======================MODULES=========================\n\n"]

def main():
    modules = os.listdir(MODULES_PATH)

    for module in modules:
        if module == "Init.luau":
            continue
        with open(MODULES_PATH+"/"+module, "r", encoding='utf-8') as f:
            try:
                LINES.append(f'''__MODULES["{module.replace(".luau", "")}"] = function()\n\treturn [===[\n\t{f.read().replace('\n', '\n\t')}]===]\nend\n''')
            except:
                continue

    LINES.append("local function require(module)\n\treturn __MODULES[module]()\nend\n--=======================================================\n\n")
    
    with open(INIT_PATH, "r", encoding='utf-8') as f:
        LINES.append(f.read())

    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.writelines(LINES)

if __name__ == "__main__":
    main()