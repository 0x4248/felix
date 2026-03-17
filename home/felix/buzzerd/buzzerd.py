#!/usr/bin/env python3
"""Simple buzzer daemon: read values from a named pipe and send them to
the Arduino over serial. Improved for maintainability and robustness.
"""
import argparse
import logging
import os
import sys
import time

try:
    import serial
except Exception as e:
    print("Missing dependency: pyserial is required", file=sys.stderr)
    raise


def open_serial(path, baud=115200, retries=5, delay=1.0):
    for attempt in range(retries):
        try:
            ser = serial.Serial(path, baud, timeout=1)
            logging.info("Opened serial %s", path)
            return ser
        except Exception as e:
            logging.warning("Failed to open serial %s: %s (attempt %d/%d)", path, e, attempt + 1, retries)
            time.sleep(delay)
    raise RuntimeError(f"Unable to open serial port {path}")


def ensure_pipe(pipe_path):
    if not os.path.exists(pipe_path):
        logging.info("Creating pipe %s", pipe_path)
        try:
            os.mkfifo(pipe_path)
            os.chmod(pipe_path, 0o666)
        except Exception:
            logging.exception("Failed to create pipe %s", pipe_path)


def main():
    parser = argparse.ArgumentParser(description="Buzzer daemon")
    parser.add_argument("--serial", default="/dev/ttyACM0")
    parser.add_argument("--pipe", default="/dev/buzzer")
    parser.add_argument("--baud", type=int, default=115200)
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s: %(message)s")

    ensure_pipe(args.pipe)

    try:
        ser = open_serial(args.serial, baud=args.baud, retries=10, delay=1.0)
    except Exception:
        logging.exception("Could not open serial port, exiting")
        sys.exit(2)

    logging.info("buzzer daemon started (serial=%s pipe=%s)", args.serial, args.pipe)

    try:
        while True:
            # Open the pipe for reading; this blocks until someone writes.
            try:
                with open(args.pipe, "r") as f:
                    for line in f:
                        cmd = line.strip()
                        if not cmd:
                            continue
                        try:
                            ser.write((cmd + "\n").encode())
                        except Exception:
                            logging.exception("Failed to write to serial; attempting to reopen")
                            ser.close()
                            ser = open_serial(args.serial, baud=args.baud, retries=5, delay=1.0)
            except FileNotFoundError:
                logging.warning("Pipe %s not found, retrying in 1s", args.pipe)
                time.sleep(1)
            except Exception:
                logging.exception("Error reading pipe; continuing")
                time.sleep(0.5)
    except KeyboardInterrupt:
        logging.info("Shutting down on user interrupt")
    finally:
        try:
            ser.close()
        except Exception:
            pass


if __name__ == "__main__":
    main()