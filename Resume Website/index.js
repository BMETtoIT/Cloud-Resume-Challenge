const counter = document.querySelector(".counter");
async function updateCounter() {
    let repsonse = await fetch("https://qp5t76llqhkufb5nexzko657ve0zdcdn.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = `Visitors: ${data}`;
}
updateCounter();