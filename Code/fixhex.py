#!/usr/bin/env python3
# hex_word_address_fixsum.py
# Usage: python3 hex_word_address_fixsum.py firmware.hex > firmware_word.hex

import sys

W = 4  # word size in bytes (change if needed, e.g. 2)
INPUT = sys.argv[1] if len(sys.argv) > 1 else "firmware.hex"

def checksum_record(byte_list):
    return (-sum(byte_list)) & 0xFF

def write_record(fout, rectype, addr16, data_bytes):
    length = len(data_bytes)
    bytes_list = [length, (addr16 >> 8) & 0xFF, addr16 & 0xFF, rectype] + list(data_bytes)
    chk = checksum_record(bytes_list)
    hexdata = "".join(f"{b:02X}" for b in bytes_list) + f"{chk:02X}"
    fout.write(":" + hexdata + "\n")

with open(INPUT, "r") as fin:
    fout = sys.stdout
    cur_in_ext_lin = 0         # upper 16 bits for input (from 04 records)
    cur_out_ext_lin = None     # last emitted upper 16 bits for output

    for raw in fin:
        line = raw.strip()
        if not line:
            continue
        if not line.startswith(":"):
            fout.write(line + "\n")
            continue

        rec_len = int(line[1:3], 16)
        addr16 = int(line[3:7], 16)
        rtype = int(line[7:9], 16)
        data_field = line[9:9+2*rec_len]
        data = bytes.fromhex(data_field) if rec_len else b""

        if rtype == 0x04:  # Extended Linear Address (input)
            # Update current input upper 16 bits, but don't emit it - we'll control outputs
            cur_in_ext_lin = int.from_bytes(data, "big")
            continue

        if rtype == 0x00:  # Data record
            full_addr = (cur_in_ext_lin << 16) | addr16
            # Convert to word addresses
            new_full = full_addr // W

            # Output possibly needs new extended linear records (upper 16 bits)
            i = 0
            remaining = data
            while remaining:
                out_hi = (new_full >> 16) & 0xFFFF
                out_lo = new_full & 0xFFFF
                if cur_out_ext_lin != out_hi:
                    # emit extended linear address record
                    write_record(fout, 0x04, 0x0000, out_hi.to_bytes(2, "big"))
                    cur_out_ext_lin = out_hi

                # space left in this 64K block
                space = 0x10000 - out_lo
                take = min(len(remaining), space)
                chunk = remaining[:take]
                write_record(fout, 0x00, out_lo, chunk)
                new_full += take
                remaining = remaining[take:]
            continue

        if rtype == 0x01:  # EOF - emit EOF as-is
            write_record(fout, 0x01, 0x0000, b"")
            # reset state if you want; typically EOF is last record
            continue

        if rtype == 0x05:  # Start Linear Address (EIP/e.g. 32-bit start address)
            # adjust start address dividing by W
            if len(data) == 4:
                start = int.from_bytes(data, "big")
                new_start = start // W
                write_record(fout, 0x05, 0x0000, new_start.to_bytes(4, "big"))
                continue
            else:
                # pass through if unexpected size
                write_record(fout, rtype, addr16, data)
                continue

        # For other record types, just pass them through unchanged (safe fallback)
        write_record(fout, rtype, addr16, data)
