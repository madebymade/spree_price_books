Spree::LineItem.class_eval do
    attr_accessor :target_shipment, :role_ids

    def options=(options={})
      return unless options.present?

      opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

      currency = opts.delete(:currency) || order.try(:currency)

      if currency
        self.currency = currency
        self.price = variant.price_in(currency, nil, opts[:role_ids]).amount +
          variant.price_modifier_amount_in(currency, opts)
      else
        self.price    = variant.price +
          variant.price_modifier_amount(opts)
      end

      self.assign_attributes opts
    end

end

