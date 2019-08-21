    ```
                              ...
                                         
                           /             \
                       prim               prim
                         |                  |
                        add                add
                       /   \              /   \
                      /    ...          ...    \
                     /                          \
                  call                          call
                 /    \                        /    \
                /     ...                    ...     \
               /                                      \
            prim                                     prim
              |                                        |
             add                                      add
            /   \                                    /   \
           /     \                                 ...    \
          /       \                                        \
       call         call                                    call
       /  \         /  \                                    /  \
    prim  prim   prim  prim                              prim  prim
                                                                 |
                                                                id

    ```