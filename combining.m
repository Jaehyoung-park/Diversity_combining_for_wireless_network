clear all;

iter_num = 100;
max_data_num = 10;
snr_mat_save = zeros(max_data_num, iter_num, max_data_num);

for data_num = 2:1:max_data_num
for iter = 1:1:iter_num

%% main 
% parameter
data_length = 11520;

% data acquisition
[rx_data_mat, snr_mat, rx_symbol_mat, tx_data] = data_acq(data_num);


for q = 1:1:data_num 
    snr_mat_save(data_num, iter, q) = snr_mat(1,q);
end

CRC_value = CRC_code(tx_data);

%% Majority voting algorithm 
% filtering 
num_comb = 1;
for i =  1:1:data_num 
    if snr_mat(1,i) > 1
        combined_set(num_comb, :) = rx_data_mat(i,:);
        combined_SNR(1, num_comb) = snr_mat(1,i);
        num_comb = num_comb + 1;
    end
end
num_comb = num_comb - 1;
max_SNR_AP = find(max(combined_SNR)==combined_SNR);

% CRC check
result = 0;
for i = 1:1:num_comb
    result = CRC_check(combined_set(i,:), CRC_value);
    if result
        corrected_data = combined_set(i,:);
        break;
    end
end

if result == 0
    for i = 1:1:data_length
        flag_bit = 0;
        for k = 1:1:num_comb
            if combined_set(k, i) == 1
                flag_bit = flag_bit + 1;
            else
                flag_bit = flag_bit - 1;
            end
        end
        if flag_bit > 0 
            corrected_data(1, i) = 1;
        elseif flag_bit < 0
            corrected_data(1, i) = 0;
        else
            corrected_data(1, i) = combined_set(max_SNR_AP, i);
        end        
    end
end


corrected_data = cast(corrected_data,'uint8');
bit_error = bitxor(tx_data, corrected_data);
N = nnz(bit_error);
bit_error_rate(data_num,iter) = N/data_length;


%% Block-based bit combining
tic
block_size = 720;
block_number = data_length/block_size;

% CRC check 
result_b = 0;
for i = 1:1:data_num
    result_b = CRC_check(rx_data_mat(i,:), CRC_value);
    if result_b
        corrected_data_block = rx_data_mat(i,:);
        break;
    end
end

% assign blocks
blocks = zeros(data_num, block_number, block_size);
for i = 1:1:data_num
    for k = 1:1:block_number
        blocks(i, k, :) = rx_data_mat(i, 1+block_size*(k-1):block_size*k);
    end
end

result_assem = 0;
if result_b == 0
    for j = 1:1:data_num^block_number
        j
        for k = 1:1:block_number
            assemble_data(1, 1+block_size*(k-1):block_size*k) = blocks(randi(data_num), k, :);
        end        
        result_assem = CRC_check(assemble_data, CRC_value);
        if result_assem
            corrected_data_block = assemble_data;
            break;
        end
    end
end

corrected_data_block = cast(corrected_data_block,'uint8');
bit_error_block = bitxor(tx_data,corrected_data_block);
N_blcok = nnz(bit_error_block);
bit_error_rate_block(data_num,iter) = N_blcok/data_length;

%% Symbol combining 
tic
for i = 1:1:data_num
    if snr_mat(1,i) > 0
        snr_mat_symcom(1,i) = snr_mat(1,i);
    else
        snr_mat_symcom(1,i) = 0;
    end
end

sum_sym = zeros(1, data_length/4);
for i = 1:1:data_num 
    for k = 1:1:data_length/4
        ele_sym(1,k) = rx_symbol_mat(i,k) * (snr_mat_symcom(1,i) / sum(snr_mat_symcom));
        sum_sym(1,k) = sum_sym(1,k) + ele_sym(1,k);
    end
end

demod_fcn_16qam = @(x) (8*(real(x)>0)) + (4*(abs(real(x))<0.6325)) + (2*(imag(x)>0)) + (1*(abs(imag(x))<0.6325));
rx_data_symcom = arrayfun(demod_fcn_16qam, sum_sym);

rx_data_re = reshape(dec2bin(rx_data_symcom)', 1, data_length);
rx_data_sym= uint8(rx_data_re) - 48;

bit_error_sym = bitxor(tx_data,rx_data_sym);
N_sym = nnz(bit_error_sym);
bit_error_rate_symcom(data_num,iter) = N_sym/data_length;


end
end