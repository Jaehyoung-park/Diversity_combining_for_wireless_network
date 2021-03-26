function [result] = CRC_check(message, CRC_value)
messageLength = 11520;
divisorDegree = 15;
divisor = uint8(ones(1,divisorDegree+1));

orig_message_CRC = [message CRC_value];

for k = 1:messageLength
    if orig_message_CRC(k)
        remainder_check = bitxor(orig_message_CRC(k:k+divisorDegree),divisor);
        orig_message_CRC(k:k+divisorDegree) = remainder_check;        
    end    
end

if any(remainder_check) 
    result = 0;
else
    result = 1;
end   
    
end