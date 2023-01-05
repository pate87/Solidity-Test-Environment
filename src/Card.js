import "./Card.css";

function Card(props) {

    function isDone() {
        if (props.done == true) {
            // return <p>This is Done</p>
            return <input type="checkbox" checked />
        } else {
            // return <p>Not Done</p>
            return <input type="checkbox" />
        }
    }

    return (
        <div className="ToDoItem">
            <p>{props.Name}</p>
            {isDone()}
        </div>
    );
}

export default Card;