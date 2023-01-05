import './App.css';
import Header from './Header';
// import MainSection from './MainSection';
import Todo from './Todo';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Header />
      </header>
      <main>
  
        <Todo />
      </main>
    </div>
  );
}

export default App;
