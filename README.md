# x86 Real Mode Kernel Program

This project demonstrates a simple boot sector kernel written in assembly for the x86 architecture. The kernel operates in **16-bit real mode** and interacts directly with the BIOS to handle low-level tasks such as reading from the disk and printing output to the screen.

## Project Overview

The main objective of this kernel is to perform a basic boot process, set up the necessary segments for execution, and read data from a sector of the disk using BIOS interrupts. It handles error conditions gracefully by printing an error message if disk reading fails.

### Key Features

1. **Real Mode Setup**:
   - The program operates in 16-bit real mode, which is the initial mode of the CPU when a system is powered on.
   - It sets up the **data segment (DS)**, **extra segment (ES)**, and **stack segment (SS)** to handle memory access properly.

2. **Interrupt Handling**:
   - The program disables interrupts during the critical setup phase using the `CLI` instruction and re-enables them once the setup is complete with the `STI` instruction.
   
3. **Disk Read via BIOS Interrupt (INT 0x13)**:
   - The kernel uses BIOS interrupt `0x13` to read a specific sector from the disk.
   - It prepares the necessary registers to specify which sector to read and where to store the data.

4. **Error Handling**:
   - If the disk read fails (checked via the **carry flag**), the program jumps to an error-handling routine, which displays an error message on the screen using BIOS interrupt `0x10`.

5. **String Output**:
   - The kernel contains a simple routine to print a string to the screen character by character using BIOS interrupt `0x10` (teletype output).

### Components of the Program

- **Segment Setup**: Configures the CPU segments for data access and stack usage.
- **Disk I/O**: Uses BIOS interrupt `0x13` to perform low-level disk operations.
- **Screen Output**: Relies on BIOS interrupt `0x10` for displaying text on the screen.
- **Error Messaging**: Provides a basic error-handling mechanism to inform the user of any failure during disk operations.

### How It Works

1. **Boot Process**: 
   - The kernel starts by jumping to a designated memory address and setting up the necessary CPU segments for data and stack operations.
   
2. **Disk Sector Read**:
   - The BIOS interrupt `0x13` is called to read a specific disk sector into memory.
   - If the operation is successful, the contents of the sector are printed to the screen.
   
3. **Error Handling**:
   - If the disk read fails, the program jumps to an error routine that prints an error message.
   
4. **Output Routine**:
   - The kernel has a basic routine to print strings to the screen using BIOS interrupts, displaying either the disk data or an error message.

### How to Build and Run

To build and run this kernel program, follow these steps:

1. **Clone the repository** and navigate to the project directory:
    ```bash
    git clone https://github.com/sudoXpg/x86_kernel_real_mode
    cd x86_kernel_real_mode
    ```

2. **Build the bootable binary** using the provided Makefile:
    ```bash
    make
    ```

    The Makefile will perform the following steps:
    - Assemble the `boot.asm` file into a binary using `nasm`.
    - Append the contents of `boot_msg.txt` to the binary file.
    - Pad the binary to ensure it is 512 bytes in size by appending zeros.

3. **Run the image** in an emulator like QEMU:
    ```bash
    qemu-system-i386 -fda boot.bin
    ```

### Clean Up

To remove the generated binary file, use:
```bash
make clean
```

### Important Notes

- **Real Mode Limitations**: Since this program operates in real mode, it can only access 1 MB of memory and interact with the hardware using BIOS interrupts.
- **BIOS Interrupts**: The program heavily relies on BIOS interrupts, particularly `INT 0x13` for disk I/O and `INT 0x10` for screen output.
- **Bootloader Role**: This kernel functions as a bootloader, meaning it handles the initial stage of booting by reading disk sectors and loading further data into memory.

### License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

