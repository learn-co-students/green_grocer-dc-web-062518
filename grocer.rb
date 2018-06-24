require 'pry'

def consolidate_cart(cart)
	new_hash = {}
	cart.each do |indiv_cart_item_hash|
		indiv_cart_item_hash.each do |item_key, price_clearance_hash|
			if new_hash == {} || new_hash.has_key?(item_key) == false
				new_hash[item_key] = price_clearance_hash
				new_hash[item_key][:count] = 1
			elsif new_hash.has_key?(item_key)
				new_hash[item_key][:count] += 1
			end
		end
	end
	new_hash
end

def apply_coupons(cart, coupons)
  new_hash = {}
  counter = 0
  cart.each do |item_key, pcc_hash|
    if coupons == []
      new_hash[item_key] = pcc_hash
    else
      coupons.each do |coupon|
        if coupon[:item] == item_key
          item_key_with_coupon = "#{item_key} W/COUPON"
          original_pcc_hash = pcc_hash
          pcc_hash[:count] -= coupon[:num]
          counter = 0
          if new_hash.has_key?(item_key_with_coupon)
            counter = new_hash[item_key_with_coupon][:count]
          end
          if pcc_hash[:count] > 0
            new_hash[item_key] = pcc_hash
            new_pcc_hash = {price: coupon[:cost], clearance: pcc_hash[:clearance], count: counter += 1}
            new_hash[item_key_with_coupon] = new_pcc_hash
          elsif pcc_hash[:count] == 0
            new_hash[item_key] = pcc_hash
            new_pcc_hash = {price: coupon[:cost], clearance: pcc_hash[:clearance], count: counter += 1}
            new_hash[item_key_with_coupon] = new_pcc_hash
          elsif pcc_hash[:count] < 0
            if new_hash.has_key?(item_key_with_coupon) == false
              new_hash[item_key] = original_pcc_hash
            elsif new_hash.has_key?(item_key_with_coupon)
              counter = new_hash[item_key_with_coupon][:count]
              pcc_hash[:count] += coupon[:num]
            end
            new_hash[item_key_with_coupon] = {price: coupon[:cost], clearance: pcc_hash[:clearance], count: counter}
          end
        else
          new_hash[item_key] = pcc_hash
        end
      end
    end
  end
  new_hash
end

def apply_clearance(cart)
  new_hash = {}
  cart.each do |item_key, pcc_hash|
    if pcc_hash[:clearance] == true
      var = pcc_hash[:price] * 0.8
      pcc_hash[:price] = var.round(2)
    end
    new_hash[item_key] == pcc_hash
  end
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated_cart, coupons)
  discount_applied = apply_clearance(coupons_applied)
  cart_total = 0
  discount_applied.each do |item_key, pcc_hash|
    cart_total += pcc_hash[:price]*pcc_hash[:count]
  end
  if cart_total > 100
    cart_total = cart_total * 0.9
  end
  cart_total
end
