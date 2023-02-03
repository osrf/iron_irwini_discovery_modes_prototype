import os
import copy

STATIC_DEFINED = "static defined"
STATIC_UNDEFINED = "static not defined" 

fields = {}
discovery_ranges = {}

# This is extremely brittle and just plain wrong but for now it works for us
for scenario in os.listdir("scenarios"):
    with open(os.path.join("scenarios", scenario)) as f:
        discovery_range = "default"
        static_defined = STATIC_UNDEFINED
        config_name = None
        for line in f:
            if "RES_DIR" in line:
                _, config_name = line.strip().split("=")
            elif "ROS_AUTOMATIC_DISCOVERY_RANGE" in line:
                _, discovery_range = line.strip().split("=")
            elif "RMW_STATIC_PEERS" in line:
                static_defined = STATIC_DEFINED

        if config_name is None:
            print("Scenario is missing RES_DIR")
            exit(-1)
        fields[config_name] = (discovery_range, static_defined)


matrix = {}
for conf1_name in fields:
    for conf2_name in fields:
        container1 = os.path.join("results", conf1_name, conf2_name, "container1")
        container2 = os.path.join("results", conf1_name, conf2_name, "container2")
        recieved_localhost = False
        recieved_otherhost = False

        disc_range_local1, static_local1 = fields[conf1_name]
        disc_range_local2, static_local2 = fields[conf2_name]        
        
        with open(container2) as f:
            for line in f:
                if "Hello" in line:
                    recieved_otherhost = True
        
        if (static_local1, disc_range_local1) not in matrix:
            matrix[(static_local1, disc_range_local1)] = {}
        matrix[(static_local1, disc_range_local1)][(static_local2, disc_range_local2)] = recieved_otherhost


def display_table(matrix):
    keys = sorted(matrix.keys())

    header1 = ""
    header2 = " "*(len(STATIC_UNDEFINED) + len("default") + 2)
    prev_static = "" 
    for key in keys:
        static_local1, disc_range_local1 = key
        if prev_static != static_local1:
            prev_static = static_local1
            header1 += " " * (len(header2) - len(header1))
            header1 += static_local1
        header2 += disc_range_local1 + " "*6


    print(header1)
    print(header2)
    prev_static = ""
    for key1 in keys:
        static_local1, disc_range_local1 = key1
        line = ""
        if static_local1 != prev_static:
            line += static_local1 + " "*(len(STATIC_UNDEFINED) + 1 - len(static_local1)) 
            prev_static = static_local1
        else:
            line += " "*(len(STATIC_UNDEFINED)+1)
        
        line += disc_range_local1 + " " * (len("default ") - len(disc_range_local1))
        for key2 in keys:
            recieved = matrix[key1][key2]
            if recieved:
                line += u'\u2713'+" " * 6
            else:
                line += u'\u2717'+" " * 6
        print(line)

print("Other Host")
display_table(matrix)
