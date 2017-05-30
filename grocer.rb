def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |food, hash|
      if new_cart[food]
        new_cart[food][:count] += 1
      else
        new_cart[food] = hash
        new_cart[food][:count] = 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    food = coupon[:item]
    if cart[food] && cart[food][:count] >= coupon[:num]
      if cart["#{food} W/COUPON"]
        cart["#{food} W/COUPON"][:count] += 1
      else
        cart["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[food][:clearance], :count => 1}
      end
      cart[food][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |food, hash|
    if hash[:clearance]
      hash[:price] = (hash[:price] * 0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  new_cart = consolidate_cart(cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  new_cart.each do |food, hash|
    total += hash[:price] * hash[:count]
  end
  if total > 100
    total *= 0.90
  end
  total
end
