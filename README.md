# Diversity_combining_for_wireless_network

[1] - Miu, Allen, Hari Balakrishnan, and Can Emre Koksal. "Improving loss resilience with multi-radio diversity in wireless networks." Proceedings of the 11th annual international conference on Mobile computing and networking. 2005.
[2] - Gowda, Mahanth, et al. "Cooperative packet recovery in enterprise WLANs." 2013 Proceedings IEEE INFOCOM. IEEE, 2013.


The combining.m file implements a bit-level diversity combining scheme using SINR-based majority voting algorithm, block-based bit-level combining scheme proposed in the paper [1], and symbol-level combining scheme proposed in paper [2] using MATLAB. 

The data_acq.m file is a MATLAB function that can be downloaded from http://warpproject.org/trac/wiki/WARPLab/Examples/OFDM, and is copyrighted by Mango Communications. 
It is a code for wireless communication using OFDM. The modulation method can be selected from BPSK, QPSK, 16-QAM, and 64-QAM modulations. 
The writer of this README.md file modified this code in the form of a function to obtain wireless signal data. 
This code can be used with the WARP board. If there is no WARP board, the USE_WARPLAB_TXRX value can be set to 0 and the noise level of the wireless channel can be arbitrarily adjusted by users.

CRC_code.m is a MATLAB function that calculates a CRC value when bit stream data is input.

CRC_check.m is a MATLAB function that yields the result of whether CRC is passed or not when bit stream and CRC are input.
