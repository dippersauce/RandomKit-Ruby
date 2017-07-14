# RandomKit.rb
# Copyright Austin "dipper" Lasota 2017
# Simple and easy pseudo number generation in pure Ruby.

require 'securerandom'

class RandomKit

	def self.MT199937(seed = nil)
		if seed == nil
			seed = SecureRandom.random_number(1 << 32)
		end
  	twister_state = [(0..624).to_a]
  	twister_state_index = 0
  	bitmask_1 = (2 ** 32) - 1
  	bitmask_2 = 2 ** 31
  	bitmask_3 = (2 ** 31) - 1
  	twister_state[0] = seed
  		(1..624).each do |i|
  			twister_state[i] = ((1812433253 * twister_state[i-1]) ^ ((twister_state[i-1] >> 30) + i)) & bitmask_1
  		end
  	if twister_state_index == 0
  		(0..624).each do |i|
  			y = (twister_state[i] & bitmask_2) + (twister_state[(i + 1 ) % 624] & bitmask_3)
        	twister_state[i] = twister_state[(i + 397) % 624] ^ (y >> 1)
        	if y % 2 != 0
        		twister_state[i] ^= 2567483615
        	end
    	end
 		y = twister_state[twister_state_index]
    	y ^= y >> 11
    	y ^= (y << 7) & 2636928640
    	y ^= (y << 15) & 4022730752
    	y ^= y >> 18
    	twister_state_index = (twister_state_index + 1) % 624
		print(y)
		end
  	end

  	def self.DeviceRandom()
  		print(SecureRandom.random_number(1 << 32))
  	end

	def self.ARC4Random(seed = nil, type)
		if seed == nil
			key = Array.new()
			256.times do
				key.push(SecureRandom.random_number(0..256))
			end
		else
			key = Array.new()
			key_PRNG = Random.new(seed)
			256.times do
				key.push(key_PRNG.rand(256))
			end
		end
		sbox = Array(0..255)
		index_pointer_x = 0
		key_size = key.length
		sbox.each do |sbox_element|    
			index_pointer_x = (index_pointer_x+sbox_element+key[sbox_element%key_size])%256
			sbox[sbox_element], sbox[index_pointer_x] = sbox[index_pointer_x], sbox[sbox_element] # Paralell assignment
		end
		x = 0
		y = 0
		entropy_seeds = Array.new()
		for integer in (0..((1536/4)+4))
			x = (x+1)%256
			y = (y+sbox[x])%256
			sbox[x], sbox[y] = sbox[y], sbox[x]
			if integer >= (1536/4)
				entropy_seeds.push(sbox[(sbox[x]+sbox[y])%256])
			end
		end
		print(entropy_seeds[0]<<24)|(entropy_seeds[1]<<16)|(entropy_seeds[2]<<8)|(entropy_seeds[3])
	end
end	
