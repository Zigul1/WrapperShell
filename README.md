# WrapperShell #

This script opens a GUI to set another PowerShell script, called "*__carrier.ps1__*", that will bring and show an image and/or some text in a Windows Form. Some graphical elements can be customized and it's possible to add one or two buttons to run some PowerShell code.

The file *carrier.ps1* can be __password protected__; the content will be encrypted with AES 256. It must be considered that the decryption time is directly proportional to the data quantity. The password is not hardcoded in *carrier.ps1*: even if it was not necessary (the wrong key will just not decrypt the cipher text), the file contains the SHA512 of a *part* of the SHA384 of a *part* of the password. The only purpose is to check the password when inserted, before trying to use it as a decipher key; considering the __*partial* multi-hashing__, is not possible to first reconstruct and then bruteforce (nor check in any dictionary or rainbow table) the correct password.

It's also possibile to set the file to __auto-delete itself__ after a custom interval; in this case, even if its window will stay displayed untill closed, after the set time the file will be *permanentely* delated (it will not just go to the Recycle Bin).

![WrapIMg](https://github.com/user-attachments/assets/0cf1dd96-b1b7-45f0-ba33-83b63df3e444)


## Usage ##
Some use cases may be:
- **protection** of text and/or images in local storage; 
- **sharing** of password protected data without using third party applications;
- **instructional** short guide with an image (also animated) and explanation text;
- **code execution** (through the buttons press), for remote maintenance or help;
- **nerd communications**, for birthdays cards or just for fun.

![PrivImg](https://github.com/user-attachments/assets/bfc33395-f793-466c-9bf9-80f5058c5136)

![2Img](https://github.com/user-attachments/assets/fa7a56b4-327b-4a93-b458-25f7cb5e36bb)

![GuideImg](https://github.com/user-attachments/assets/3eaa4048-2d3e-464e-b2b3-4fd8d729eafe)

![BdayImg](https://github.com/user-attachments/assets/04ed31d6-482c-46b6-b8da-5906eaae1ce1)

