import { useState } from 'react';
import { Button } from 'react-bootstrap';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

function State() {

    /**
     * Declare State variables
     * create a variable and and a linked function = const [var, function]
     * useState initialize the state of the variable = useState()
     * The function declared in the variable can used to set the value to a variable
     */
    // const [time, setTime] = useState(5);
    const [time, setTime] = useState(0);

    function increase() {
        // setTime(10);
        /**
         * Set the value of useState to the linked variable
         */
        setTime((time) => time + 1);
    }

    function decrease() {
        setTime((time) => time - 1);
    }

    return (
        <Container>
            <Container>
                <Row>
                    <Col><p>{time}</p></Col>
                </Row>
            </Container>
            
            <Container>
                <Row>
                    <Col>
                        <Button onClick={increase}>increase</Button>
                    </Col>
                    <Col><Button onClick={decrease}>decrease</Button></Col>
                </Row>
            </Container>
            
        </Container>
    );
}

export default State;
