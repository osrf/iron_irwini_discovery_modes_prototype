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
            elif "ROS_STATIC_PEERS" in line:
                static_defined = STATIC_DEFINED

        if config_name is None:
            print("Scenario is missing RES_DIR")
            exit(-1)
        fields[config_name] = (static_defined, discovery_range)


def samehost_expectation(k1, k2):
    (static_peers1, disc_range1) = k1
    (static_peers2, disc_range2) = k2
    # If the static peer is set for the localhost, then discovery within
    # localhost should always succeed.
    if static_peers1 == STATIC_DEFINED or static_peers2 == STATIC_DEFINED:
        return True

    # If the static peer is not set for the localhost and the range is off, then
    # discovery within localhost should never succeed.
    if disc_range1 == 'OFF' or disc_range2 == 'OFF':
        return False

    # In all other situations, discovery within localhost should succeed.
    return True


def otherhost_expectation(k1, k2):
    (static_peers1, disc_range1) = k1
    (static_peers2, disc_range2) = k2
    # If the static peer is set on either end, then discovery across the hosts
    # should always succeed.
    if static_peers1 == STATIC_DEFINED or static_peers2 == STATIC_DEFINED:
        return True

    # If the static peer is not set across hosts and either's range is off, then
    # discovery across hosts should never succeed.
    if disc_range1 == 'OFF' or disc_range2 == 'OFF':
        return False

    # If the static peer is not set across hosts and either's range is only
    # localhost, then discovery across hosts should never succeed.
    if disc_range1 == 'LOCALHOST' or disc_range2 == 'LOCALHOST':
        return False

    # In all other situations, discovery across hosts should succeed.
    return True


samehost_matrix = {}
otherhost_matrix = {}
for conf1_name in fields:
    for conf2_name in fields:
        samehost_container = os.path.join("results/samehost", conf1_name, conf2_name, "subscriber")
        otherhost_container = os.path.join("results/otherhost", conf1_name, conf2_name, "subscriber")
        received_samehost = None
        received_otherhost = None

        try:
            with open(samehost_container) as f:
                received_samehost = False
                for line in f:
                    if "Hello" in line:
                        received_samehost = True
        except:
            # This means the subscriber output file failed to be created at all.
            # received_samehost will remain None and the test will fail
            pass

        try:
            with open(otherhost_container) as f:
                received_otherhost = False
                for line in f:
                    if "Hello" in line:
                        received_otherhost = True
        except:
            # This means the subscriber output file failed to be created at all.
            # received_otherhost will remain None and the test will fail
            pass

        k1 = fields[conf1_name]
        k2 = fields[conf2_name]
        samehost_matrix.setdefault(k1, {})[k2] = received_samehost == samehost_expectation(k1, k2)
        otherhost_matrix.setdefault(k1, {})[k2] = received_otherhost == otherhost_expectation(k1, k2)

def column_text_widths(keys):
    static_peers_len = 0
    disc_range_len = 0
    for static_peers, disc_range in keys:
        static_peers_len = max([static_peers_len, len(static_peers)])
        disc_range_len = max([disc_range_len, len(disc_range)])
    return (static_peers_len + 2, disc_range_len + 2)


def display_table(matrix):
    keys = sorted(matrix.keys())

    static_width, disc_width = column_text_widths(keys)
    header1 = ""
    header2 = " "*(static_width + disc_width)

    prev_static = ""
    for key in keys:
        static_peers1, disc_range1 = key
        if prev_static != static_peers1:
            prev_static = static_peers1
            header1 += " " * (len(header2) - len(header1))
            header1 += static_peers1
        header2 += disc_range1 + " "*(disc_width - len(disc_range1))

    print(header1)
    print(header2)
    prev_static = ""
    for key1 in keys:
        static_peers1, disc_range1 = key1
        line = ""
        if static_peers1 != prev_static:
            line += static_peers1 + " "*(static_width - len(static_peers1))
            prev_static = static_peers1
        else:
            line += " "*static_width

        line += disc_range1 + " " * (disc_width - len(disc_range1))
        for key2 in keys:
            received = matrix[key1][key2]
            if received:
                line += u'\u2713'+" " * (disc_width - 1)
            else:
                line += u'\u2717'+" " * (disc_width - 1)
        print(line)

print("Same Host")
display_table(samehost_matrix)

print("\nOther Host")
display_table(otherhost_matrix)
