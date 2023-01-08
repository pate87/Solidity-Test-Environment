import './App.css';
import Header from './Header';
import State from './State';
// import MainSection from './MainSection';
import Todo from './Todo';
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Header />
      </header>
      <main>
        <State />
        <Todo />
      </main>
    </div>
  );
}

export default App;
