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