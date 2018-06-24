require 'pry'
def consolidate_cart(cart)
  cart.each_with_object({}) do |items, new_cart|
    items.each do |k, v|
      new_cart[k] ||= {}
      new_cart[k] = v
      if new_cart[k][:count]
         new_cart[k][:count] +=1
      else
        new_cart[k][:count] = 1
      end
    end
  end
end

def apply_coupons(cart, coupons)
  result = {}
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
           result["#{food} W/COUPON"][:count] += 1
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    result[food] = info
  end
  result
end

def apply_clearance(cart)
  cart.each do |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated_cart, coupons)
  cart_discounts = apply_clearance(coupons_applied)
  total = 0
  cart_discounts.each do |item_key, item_hash|
    total += item_hash[:price]*item_hash[:count]
  end
  if total > 100
     total = total * 0.9
  end
  total
end
