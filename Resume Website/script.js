fetch('https://27rxdqluda.execute-api.us-east-1.amazonaws.com/test')
    .then(response => response.json())
    .then((data) => {
        document.getElementById('visitor_count').innerText = data
    })

Visitor Count:
    <span id="visitor_count" />