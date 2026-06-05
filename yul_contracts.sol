object "Simple" {

    code {

        ...
    }

    object "runtime" {

        code {

            mstore(0,2)

            return(0,32)

        }
    }
}
constructor

↓

dispatcher

↓

helper functions

↓

storage position functions

↓

return helpers

↓

business logic