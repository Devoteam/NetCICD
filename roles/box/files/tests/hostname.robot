*** Settings ***
Documentation     Testing the correct setting of the hostname.
...
...               This test has a workflow similar to the keyword-driven
...               examples. The difference is that the keywords use higher
...               abstraction level and their arguments are embedded into
...               the keyword names.
...
...               This kind of _gherkin_ syntax has been made popular by
...               [http://cukes.info|Cucumber]. It works well especially when
...               tests act as examples that need to be easily understood also
...               by the business people.
Library           CalculatorLibrary.py

*** Test Cases ***
Addition
    Given calculator has been cleared
    When user types "1 + 1"
    and user pushes equals
    Then result is "2"

Hostname set correctly
    Given both the node and the configuration language are defined
    When we execute the command "sh run | in hostname"
    Then we see the hostname set correctly

*** Keywords ***
Both the node and the configuration language are defined

We execute the command "sh run | in hostname"

We see the hostname set correctly

Calculator has been cleared
    Push button    C

User types "${expression}"
    Push buttons    ${expression}

User pushes equals
    Push button    =

Result is "${result}"
    Result should be    ${result}
