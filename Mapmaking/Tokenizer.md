
In Superfighters Deluxe maps are locked down by a special token. It's the same token that the game generates in order to lock official maps in the game. You can obtain this code by running this JavaScript code (you can do that inside your own browser).

```js
function officialToken(author, name) {
  const header = name + author;
  
  let array = "0123456789".split('');
  const length = array.length;

  for (let i = 0; i < header.length; i++) {
      let index = i % length;

      let newCharCode = array[index].charCodeAt(0) + header.charCodeAt(index);
      array[index] = String.fromCharCode(newCharCode);
  }

  array[0] = '1';
  
  const bytes = new TextEncoder().encode(array.join(''));
  const token = Array.from(bytes)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .toUpperCase();
  
  return token;
}

console.log(officialToken("Odex", "DemoMap"));
```

You should get a hexadecimal value, paste that with an Hex Editor inside your map file after the `h_mt` keyword. The full line should be something like `SFDMAPEDIT`, you have to replace that with the new string you got from this function.