
use std::fs::File;
use std::io::{Cursor, Read, Seek, SeekFrom};

extern crate bytes;
use bytes::Buf;


fn main() {
    let mut file = File::open("/tmp/data.dat").unwrap();
    file.seek(SeekFrom::Start(8)).unwrap();

    let mut sum = 0f32;

    for _ii in 0..4 {
        let mut tmp = [0u8; 4];
        file.read_exact(&mut tmp).unwrap();
        let xx = Cursor::new(tmp).get_f32_le();
        sum += xx;
    }

    println!("sum = {}", sum);
}
