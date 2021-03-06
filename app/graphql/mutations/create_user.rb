# Mutation resolver to create a new User
class Mutations::CreateUser < GraphQL::Function
    # Define a new GraphQL input object type for new user authentication
    AuthProviderInput = GraphQL::InputObjectType.define do
        name 'AuthProviderSignupData'

        argument :credentials, Types::AuthProviderCredInput
    end

    # Arguments passed as 'args' needed tp create a new User
    argument :name, !types.String
    argument :authProvider, !AuthProviderInput

    # Define return type for the mutation of User node
    type Types:: UserType

    # The mutation method for creating a new User
    # _obj - parent object, which in this case is nil
    # args - arguments passed (name, email, password)
    # _ctx - GraphQL Context
    def call(_obj, args, _ctx)
        # Create new User
        User.create!(
            name: args[:name],
            email: args[:authProvider][:credentials][:email],
            password: args[:authProvider][:credentials][:password]
        )

        # Catch all validation errors
    rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid input: #{
            e.record.errors.full_messages.join(', ')
            }")
    end
end
 