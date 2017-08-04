import serial
import struct
import sys
import signal
import csv

def decode_unsigned_int(string):
    """
    Return the unsigned int coded in the hex string
    """
    return int(string,16)

def decode_signed_int(string):
    """
    Return the signed int coded in the hex string
    """
    print(string)
    hex_code = bytes.fromhex(string)
    unpacked = struct.unpack('>i', hex_code)
    return unpacked[0]

def decode_float(string):
    """
    Return the float coded in the hex string
    """
    hex_code = bytes.fromhex(string)
    unpacked = struct.unpack('>f', hex_code)
    return unpacked[0]

def decode_double(string):
    """
    Return the double coded in the hex string
    """
    hex_code = bytes.fromhex(string)
    unpacked = struct.unpack('>d', hex_code)
    return unpacked[0]

def decode_bitmask(string):
    """
    Return the bitmask coded in the hex string
    """
    return bin(int(string, 16))

def decode_string(string):
    """
    Return the string as is
    """
    return string

def select_codec(codec_id):
    """
    Return a different coded depending on the codec_id
    """
    if codec_id == 'u':
        return decode_unsigned_int
    elif codec_id == 'i':
        return decode_signed_int
    elif codec_id == 'f':
        return decode_float
    elif codec_id == 'b':
        return decode_bitmask
    elif codec_id == 's':
        return decode_string
    elif codec_id == 'd':
        return decode_double

class Codec:
    """
    Class for decoding a message coming from the EVB1000 serial.

    The type_code decides the structure of the message.
    """

    def __init__(self, type_code):
        self.type_code = type_code

        # initialize the codec
        self.items_sizes = []
        self.items_codec = []
        self.init_codec()

    def init_codec(self):
        """
        Initialize the codec.

        items_coded decides the fixed structure of the message.

        # self.keys = ['range_num', 'master_id', 'src_id',
        #              'dest_id', 'range', 'flag']

        anc_report := msg_name,   range_number,  master_id,   source_id 
                      (string)    (unsigned),    (unsigned),  (unsigned)
                      
                      dest_id,    range_value,   anch_resp_rx_or_anch_final_rx
                      (unsigned), (float),       (string)
        
        tag_report := msg_name,   range_number,  range_to_0,  range_to_1,
                      (string),   (unsigned),    (unsigned),  (unsigned)

                      range_to_2, range_to_3
                      (unsigned), (unsigned)
        """
        
        if self.type_code == 'anc_report':
            self.items_codec = ['s'] + ['u'] * 4 + ['f'] + ['s']
        elif self.type_code == 'tag_report':
            self.items_codec = ['s'] + ['u'] * 5

    def decode_data(self, string):
        """
        Return a list of values decoded according to the structure
        described by items_codec
        """
        items = string.split(' ')
        decoded = []
        
        # remove string containing the type_code
        # items = items[1:]
        
        for index, item in enumerate(items):
            # in case the items_coded contains less items
            # than the effective message
            if index < len(self.items_codec):
                codec_id = self.items_codec[index]
                codec = select_codec(codec_id)
                decoded.append(codec(item))

        return decoded

class DataFromEVB:
    """
    Represents a message coming from the EVB serial line
    """
    def __init__(self, bytedata):
        #remove trailing '\r\n' from the data
        bytedata = bytedata[:-2]
        
        self.string = bytedata.decode('utf-8')
        self.decode_type()

    @property
    def type_code(self):
        return self._type_code

    @type_code.setter
    def type_code(self, value):
        self._type_code = value

    @property
    def keys(self):
        return self._keys

    @keys.setter
    def keys(self, value):
        self._keys = value

    def decode_type(self):
        """
        Determine if the message is valid depending on its type_code.
        If the message is valid set the keys that depends on the type_code.
        """
        
        if len(self.string) < 10:
            self.type_code =  None

        self.type_code = self.string[0:10]
        
        if self.type_code == 'anc_report':
            self.keys = ['msg_name', 'range_num', 'master_id', 'src_id',
                         'dest_id', 'range', 'flag']
        elif self.type_code == 'tag_report':
            self.keys = ['msg_name', 'range_num', 'r0', 'r1', 'r2', 'r3']
        else:
            self.type_code = None

    def decode_data(self):
        """
        Decode the message coded in self.string.

        Return a dictionary obtained from self.keys and the values
        returned by the Codec.
        """
        if self.type_code == None:
            return None
        else:
            return dict(zip(self.keys, Codec(self.type_code).decode_data(self.string)))

class Logger:
    """
    Save data from the EVB1000 serial to file.
    """

    def __init__(self, filename):
        self.filename = filename
        self.file = open(self.filename + '.csv', 'w')
        self.first_write = False
        
    def add_data(self, evb1000_data):
        """
        Log new data.
        """
        # write new data

        decoded_data = evb1000_data.decode_data()

        if decoded_data != None:
            if not self.first_write:
                self.writer = csv.DictWriter(self.file, evb1000_data.keys)
                self.writer.writeheader()
                self.first_write = True

            self.writer.writerow(evb1000_data.decode_data())

    def __enter__(self):
        return self

    def __exit__(self ,type, value, traceback):
        """
        Close all the files when the logger is destroyed.
        """
        # for file_key in self.files:
        #     self.files[file_key].close()
        self.file.close()

def run(file_prefix, serial_path, baud):
    logger = Logger(file_prefix)

    with Logger(file_prefix) as logger:
        while True:
            # tries to connect to the serial device until is ready
            try:
                with serial.Serial(serial_path, baud, timeout=20) as ser:
                    print('serial connected')
                    while True:
                        line_byte = ser.readline()
                        print(line_byte)
                        if len(line_byte) != 0:
                            data = DataFromEVB(line_byte)
                            logger.add_data(data)
                                                    
            except serial.serialutil.SerialException:
                # in case the evb1000 serial is not ready
                pass
            # data = DataFromEVB(b'mc ff ffffffff ffffffff ffffffff ffffffff ffff ff ff t0:0\r\n')
            # logger.add_data(data)

# sys.exit cause the __exit__ method of Logger to be called
signal.signal(signal.SIGTERM, lambda signal, frame: sys.exit(0))

if __name__ == '__main__':
    # argv[1] := output file name
    # argv[2] := serial device path
    run(sys.argv[1], sys.argv[2], 115200)
