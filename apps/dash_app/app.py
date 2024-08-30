import os
import dash
from dash import html, dcc
from dash.dependencies import Input, Output
from textblob import TextBlob

app = dash.Dash(
    __name__,
    suppress_callback_exceptions=True,
    requests_pathname_prefix=os.environ['SHINYPROXY_PUBLIC_PATH'],
    routes_pathname_prefix=os.environ['SHINYPROXY_PUBLIC_PATH']
)
server = app.server

app.layout = html.Div([
    html.H1('Simple Sentiment Analysis App'),
    dcc.Textarea(
        id='text-input',
        value='',
        style={'width': '100%', 'height': 100},
        placeholder='Enter text here...'
    ),
    html.Button('Analyze', id='analyze-button'),
    html.Div(id='output-container')
])

@app.callback(
    Output('output-container', 'children'),
    [Input('analyze-button', 'n_clicks')],
    [dash.dependencies.State('text-input', 'value')]
)
def update_output(n_clicks, input_value):
    if n_clicks and input_value:
        analysis = TextBlob(input_value)
        sentiment_polarity = analysis.sentiment.polarity
        sentiment = 'Positive' if sentiment_polarity > 0 else 'Negative' if sentiment_polarity < 0 else 'Neutral'
        return f'Sentiment: {sentiment} (Polarity: {sentiment_polarity})'
    return 'Enter some text and click Analyze.'

if __name__ == '__main__':
  
    app.run_server(debug=True)
