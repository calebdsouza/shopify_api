# Mutation resolver to create a new Product
class Mutations::CreateProduct < GraphQL::Function
    # Arguments passed as 'args' needed to create a new product
    argument :title, !types.String
    argument :price, !types.Float
    argument :inventory_count, !types.Int
    
    # Define return type from the mutation of Product node
    type Types::ProductType

    # The mutataion method for creating a new Product
    # _obj - parent object, which in this case is nil
    # args - arguments passed (title, price, inventory_count)
    # _ctx - GraphQL context
    def call(_obj, args, _ctx)
        unless args[:price]
            raise GraphQL::ExecutionError.new('Price cannot be negative')
        end

        unless args[:inventory_count]
            raise GraphQL::ExecutionError.new('Product cnnot have negative inventory')
        end

        # Create new Product
        Product.create!(
            title: args[:title],
            price: args[:price],
            inventory_count: args[:inventory_count],
        )

        # Catch all validation errors
    rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid input: #{
            e.record.errors.full_messages.join(', ')
            }")
    end
end
