# AutoGPT API Reference

_Generated automatically on 2025-11-14 22:23 UTC_

## Module: `autogpt.__init__`

No description available.

---

## Module: `autogpt.__main__`

Auto-GPT: A GPT powered AI Assistant

---

## Module: `autogpt.agent.__init__`

No description available.

---

## Module: `autogpt.agent.agent`

No description available.

### Classes

#### `Agent`

Agent class for interacting with Auto-GPT.

Attributes:
    ai_name: The name of the agent.
    memory: The memory object to use.
    full_message_history: The full message history.
    next_action_count: The number of actions to execute.
    system_prompt: The system prompt is the initial prompt that defines everything
      the AI needs to know to achieve its task successfully.
    Currently, the dynamic and customizable information in the system prompt are
      ai_name, description and goals.

    triggering_prompt: The last sentence the AI will see before answering.
        For Auto-GPT, this prompt is:
        Determine which next command to use, and respond using the format specified
          above:
        The triggering prompt is not part of the system prompt because between the
          system prompt and the triggering
        prompt we have contextual information that can distract the AI and make it
          forget that its goal is to find the next task to achieve.
        SYSTEM PROMPT
        CONTEXTUAL INFORMATION (memory, previous conversations, anything relevant)
        TRIGGERING PROMPT

    The triggering prompt reminds the AI about its short term meta task
    (defining the next task)

Example:

```python
from autogpt.agent.agent import Agent

agent = Agent(...)
```

##### Methods

- `start_interaction_loop(self)`: No description available.

  Example:

```python
agent = Agent(...)
agent.start_interaction_loop(...)
```

- `get_self_feedback(self, thoughts: dict, llm_model: str)`: Generates a feedback response based on the provided thoughts dictionary.
This method takes in a dictionary of thoughts containing keys such as 'reasoning',
'plan', 'thoughts', and 'criticism'. It combines these elements into a single
feedback message and uses the create_chat_completion() function to generate a
response based on the input message.
Args:
    thoughts (dict): A dictionary containing thought elements like reasoning,
    plan, thoughts, and criticism.
Returns:
    str: A feedback response generated using the provided thoughts dictionary.

  Example:

```python
agent = Agent(...)
agent.get_self_feedback(...)
```

---

## Module: `autogpt.agent.agent_manager`

Agent manager for managing GPT agents

### Classes

#### `AgentManager`

Agent manager for managing GPT agents

Example:

```python
from autogpt.agent.agent_manager import AgentManager

agentManager = AgentManager(...)
```

##### Methods

- `create_agent(self, task: str, prompt: str, model: str)`: Create a new agent and return its key

Args:
    task: The task to perform
    prompt: The prompt to use
    model: The model to use

Returns:
    The key of the new agent

  Example:

```python
agentManager = AgentManager(...)
agentManager.create_agent(...)
```

- `message_agent(self, key: str | int, message: str)`: Send a message to an agent and return its response

Args:
    key: The key of the agent to message
    message: The message to send to the agent

Returns:
    The agent's response

  Example:

```python
agentManager = AgentManager(...)
agentManager.message_agent(...)
```

- `list_agents(self)`: Return a list of all agents

Returns:
    A list of tuples of the form (key, task)

  Example:

```python
agentManager = AgentManager(...)
agentManager.list_agents(...)
```

- `delete_agent(self, key: str | int)`: Delete an agent from the agent manager

Args:
    key: The key of the agent to delete

Returns:
    True if successful, False otherwise

  Example:

```python
agentManager = AgentManager(...)
agentManager.delete_agent(...)
```

---

## Module: `autogpt.api_manager`

No description available.

### Classes

#### `ApiManager`

No description available.

Example:

```python
from autogpt.api_manager import ApiManager

apiManager = ApiManager(...)
```

##### Methods

- `reset(self)`: No description available.

  Example:

```python
apiManager = ApiManager(...)
apiManager.reset(...)
```

- `create_chat_completion(self, messages: list, model: str | None=None, temperature: float=None, max_tokens: int | None=None, deployment_id=None)`: Create a chat completion and update the cost.
Args:
messages (list): The list of messages to send to the API.
model (str): The model to use for the API call.
temperature (float): The temperature to use for the API call.
max_tokens (int): The maximum number of tokens for the API call.
Returns:
str: The AI's response.

  Example:

```python
apiManager = ApiManager(...)
apiManager.create_chat_completion(...)
```

- `update_cost(self, prompt_tokens, completion_tokens, model)`: Update the total cost, prompt tokens, and completion tokens.

Args:
prompt_tokens (int): The number of tokens used in the prompt.
completion_tokens (int): The number of tokens used in the completion.
model (str): The model used for the API call.

  Example:

```python
apiManager = ApiManager(...)
apiManager.update_cost(...)
```

- `set_total_budget(self, total_budget)`: Sets the total user-defined budget for API calls.

Args:
prompt_tokens (int): The number of tokens used in the prompt.

  Example:

```python
apiManager = ApiManager(...)
apiManager.set_total_budget(...)
```

- `get_total_prompt_tokens(self)`: Get the total number of prompt tokens.

Returns:
int: The total number of prompt tokens.

  Example:

```python
apiManager = ApiManager(...)
apiManager.get_total_prompt_tokens(...)
```

- `get_total_completion_tokens(self)`: Get the total number of completion tokens.

Returns:
int: The total number of completion tokens.

  Example:

```python
apiManager = ApiManager(...)
apiManager.get_total_completion_tokens(...)
```

- `get_total_cost(self)`: Get the total cost of API calls.

Returns:
float: The total cost of API calls.

  Example:

```python
apiManager = ApiManager(...)
apiManager.get_total_cost(...)
```

- `get_total_budget(self)`: Get the total user-defined budget for API calls.

Returns:
float: The total budget for API calls.

  Example:

```python
apiManager = ApiManager(...)
apiManager.get_total_budget(...)
```

---

## Module: `autogpt.app`

Command and Control 

### Functions

#### `is_valid_int(value: str)`

Check if the value is a valid integer

Args:
    value (str): The value to check

Returns:
    bool: True if the value is a valid integer, False otherwise

Example:

```python
from autogpt.app import is_valid_int

is_valid_int(...)
```

#### `get_command(response_json: Dict)`

Parse the response and return the command name and arguments

Args:
    response_json (json): The response from the AI

Returns:
    tuple: The command name and arguments

Raises:
    json.decoder.JSONDecodeError: If the response is not valid JSON

    Exception: If any other error occurs

Example:

```python
from autogpt.app import get_command

get_command(...)
```

#### `map_command_synonyms(command_name: str)`

Takes the original command name given by the AI, and checks if the
string matches a list of common/known hallucinations

Example:

```python
from autogpt.app import map_command_synonyms

map_command_synonyms(...)
```

#### `execute_command(command_registry: CommandRegistry, command_name: str, arguments, prompt: PromptGenerator)`

Execute the command and return the result

Args:
    command_name (str): The name of the command to execute
    arguments (dict): The arguments for the command

Returns:
    str: The result of the command

Example:

```python
from autogpt.app import execute_command

execute_command(...)
```

#### `get_text_summary(url: str, question: str)`

Return the results of a Google search

Args:
    url (str): The url to scrape
    question (str): The question to summarize the text for

Returns:
    str: The summary of the text

Example:

```python
from autogpt.app import get_text_summary

get_text_summary(...)
```

#### `get_hyperlinks(url: str)`

Return the results of a Google search

Args:
    url (str): The url to scrape

Returns:
    str or list: The hyperlinks on the page

Example:

```python
from autogpt.app import get_hyperlinks

get_hyperlinks(...)
```

#### `shutdown()`

Shut down the program

Example:

```python
from autogpt.app import shutdown

shutdown(...)
```

#### `start_agent(name: str, task: str, prompt: str, model=CFG.fast_llm_model)`

Start an agent with a given name, task, and prompt

Args:
    name (str): The name of the agent
    task (str): The task of the agent
    prompt (str): The prompt for the agent
    model (str): The model to use for the agent

Returns:
    str: The response of the agent

Example:

```python
from autogpt.app import start_agent

start_agent(...)
```

#### `message_agent(key: str, message: str)`

Message an agent with a given key and message

Example:

```python
from autogpt.app import message_agent

message_agent(...)
```

#### `list_agents()`

List all agents

Returns:
    str: A list of all agents

Example:

```python
from autogpt.app import list_agents

list_agents(...)
```

#### `delete_agent(key: str)`

Delete an agent with a given key

Args:
    key (str): The key of the agent to delete

Returns:
    str: A message indicating whether the agent was deleted or not

Example:

```python
from autogpt.app import delete_agent

delete_agent(...)
```

---

## Module: `autogpt.chat`

No description available.

### Functions

#### `create_chat_message(role, content)`

Create a chat message with the given role and content.

Args:
role (str): The role of the message sender, e.g., "system", "user", or "assistant".
content (str): The content of the message.

Returns:
dict: A dictionary containing the role and content of the message.

Example:

```python
from autogpt.chat import create_chat_message

create_chat_message(...)
```

#### `generate_context(prompt, relevant_memory, full_message_history, model)`

No description available.

Example:

```python
from autogpt.chat import generate_context

generate_context(...)
```

#### `chat_with_ai(agent, prompt, user_input, full_message_history, permanent_memory, token_limit)`

Interact with the OpenAI API, sending the prompt, user input, message history,
and permanent memory.

Example:

```python
from autogpt.chat import chat_with_ai

chat_with_ai(...)
```

---

## Module: `autogpt.cli`

Main script for the autogpt package.

### Functions

#### `main(ctx: click.Context, continuous: bool, continuous_limit: int, ai_settings: str, skip_reprompt: bool, speak: bool, debug: bool, gpt3only: bool, gpt4only: bool, memory_type: str, browser_name: str, allow_downloads: bool, skip_news: bool, workspace_directory: str, install_plugin_deps: bool)`

Welcome to AutoGPT an experimental open-source application showcasing the capabilities of the GPT-4 pushing the boundaries of AI.

Start an Auto-GPT assistant.

Example:

```python
from autogpt.cli import main

main(...)
```

---

## Module: `autogpt.commands.__init__`

No description available.

---

## Module: `autogpt.commands.analyze_code`

Code evaluation module.

### Functions

#### `analyze_code(code: str)`

A function that takes in a string and returns a response from create chat
  completion api call.

Parameters:
    code (str): Code to be evaluated.
Returns:
    A result string from create chat completion. A list of suggestions to
        improve the code.

Example:

```python
from autogpt.commands.analyze_code import analyze_code

analyze_code(...)
```

---

## Module: `autogpt.commands.audio_text`

Commands for converting audio to text.

### Functions

#### `read_audio_from_file(filename: str)`

Convert audio to text.

Args:
    filename (str): The path to the audio file

Returns:
    str: The text from the audio

Example:

```python
from autogpt.commands.audio_text import read_audio_from_file

read_audio_from_file(...)
```

#### `read_audio(audio: bytes)`

Convert audio to text.

Args:
    audio (bytes): The audio to convert

Returns:
    str: The text from the audio

Example:

```python
from autogpt.commands.audio_text import read_audio

read_audio(...)
```

---

## Module: `autogpt.commands.command`

No description available.

### Functions

#### `command(name: str, description: str, signature: str='', enabled: bool=True, disabled_reason: Optional[str]=None)`

The command decorator is used to create Command objects from ordinary functions.

Example:

```python
from autogpt.commands.command import command

command(...)
```

### Classes

#### `Command`

A class representing a command.

Attributes:
    name (str): The name of the command.
    description (str): A brief description of what the command does.
    signature (str): The signature of the function that the command executes. Defaults to None.

Example:

```python
from autogpt.commands.command import Command

command = Command(...)
```

#### `CommandRegistry`

The CommandRegistry class is a manager for a collection of Command objects.
It allows the registration, modification, and retrieval of Command objects,
as well as the scanning and loading of command plugins from a specified
directory.

Example:

```python
from autogpt.commands.command import CommandRegistry

commandRegistry = CommandRegistry(...)
```

##### Methods

- `register(self, cmd: Command)`: No description available.

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.register(...)
```

- `unregister(self, command_name: str)`: No description available.

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.unregister(...)
```

- `reload_commands(self)`: Reloads all loaded command plugins.

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.reload_commands(...)
```

- `get_command(self, name: str)`: No description available.

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.get_command(...)
```

- `call(self, command_name: str, **kwargs)`: No description available.

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.call(...)
```

- `command_prompt(self)`: Returns a string representation of all registered `Command` objects for use in a prompt

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.command_prompt(...)
```

- `import_commands(self, module_name: str)`: Imports the specified Python module containing command plugins.

This method imports the associated module and registers any functions or
classes that are decorated with the `AUTO_GPT_COMMAND_IDENTIFIER` attribute
as `Command` objects. The registered `Command` objects are then added to the
`commands` dictionary of the `CommandRegistry` object.

Args:
    module_name (str): The name of the module to import for command plugins.

  Example:

```python
commandRegistry = CommandRegistry(...)
commandRegistry.import_commands(...)
```

---

## Module: `autogpt.commands.execute_code`

Execute code in a Docker container

### Functions

#### `execute_python_file(filename: str)`

Execute a Python file in a Docker container and return the output

Args:
    filename (str): The name of the file to execute

Returns:
    str: The output of the file

Example:

```python
from autogpt.commands.execute_code import execute_python_file

execute_python_file(...)
```

#### `execute_shell(command_line: str)`

Execute a shell command and return the output

Args:
    command_line (str): The command line to execute

Returns:
    str: The output of the command

Example:

```python
from autogpt.commands.execute_code import execute_shell

execute_shell(...)
```

#### `execute_shell_popen(command_line)`

Execute a shell command with Popen and returns an english description
of the event and the process id

Args:
    command_line (str): The command line to execute

Returns:
    str: Description of the fact that the process started and its id

Example:

```python
from autogpt.commands.execute_code import execute_shell_popen

execute_shell_popen(...)
```

#### `we_are_running_in_a_docker_container()`

Check if we are running in a Docker container

Returns:
    bool: True if we are running in a Docker container, False otherwise

Example:

```python
from autogpt.commands.execute_code import we_are_running_in_a_docker_container

we_are_running_in_a_docker_container(...)
```

---

## Module: `autogpt.commands.file_operations`

File operations for AutoGPT

### Functions

#### `check_duplicate_operation(operation: str, filename: str)`

Check if the operation has already been performed on the given file

Args:
    operation (str): The operation to check for
    filename (str): The name of the file to check for

Returns:
    bool: True if the operation has already been performed on the file

Example:

```python
from autogpt.commands.file_operations import check_duplicate_operation

check_duplicate_operation(...)
```

#### `log_operation(operation: str, filename: str)`

Log the file operation to the file_logger.txt

Args:
    operation (str): The operation to log
    filename (str): The name of the file the operation was performed on

Example:

```python
from autogpt.commands.file_operations import log_operation

log_operation(...)
```

#### `split_file(content: str, max_length: int=4000, overlap: int=0)`

Split text into chunks of a specified maximum length with a specified overlap
between chunks.

:param content: The input text to be split into chunks
:param max_length: The maximum length of each chunk,
    default is 4000 (about 1k token)
:param overlap: The number of overlapping characters between chunks,
    default is no overlap
:return: A generator yielding chunks of text

Example:

```python
from autogpt.commands.file_operations import split_file

split_file(...)
```

#### `read_file(filename: str)`

Read a file and return the contents

Args:
    filename (str): The name of the file to read

Returns:
    str: The contents of the file

Example:

```python
from autogpt.commands.file_operations import read_file

read_file(...)
```

#### `ingest_file(filename: str, memory, max_length: int=4000, overlap: int=200)`

Ingest a file by reading its content, splitting it into chunks with a specified
maximum length and overlap, and adding the chunks to the memory storage.

:param filename: The name of the file to ingest
:param memory: An object with an add() method to store the chunks in memory
:param max_length: The maximum length of each chunk, default is 4000
:param overlap: The number of overlapping characters between chunks, default is 200

Example:

```python
from autogpt.commands.file_operations import ingest_file

ingest_file(...)
```

#### `write_to_file(filename: str, text: str)`

Write text to a file

Args:
    filename (str): The name of the file to write to
    text (str): The text to write to the file

Returns:
    str: A message indicating success or failure

Example:

```python
from autogpt.commands.file_operations import write_to_file

write_to_file(...)
```

#### `append_to_file(filename: str, text: str, should_log: bool=True)`

Append text to a file

Args:
    filename (str): The name of the file to append to
    text (str): The text to append to the file
    should_log (bool): Should log output

Returns:
    str: A message indicating success or failure

Example:

```python
from autogpt.commands.file_operations import append_to_file

append_to_file(...)
```

#### `delete_file(filename: str)`

Delete a file

Args:
    filename (str): The name of the file to delete

Returns:
    str: A message indicating success or failure

Example:

```python
from autogpt.commands.file_operations import delete_file

delete_file(...)
```

#### `search_files(directory: str)`

Search for files in a directory

Args:
    directory (str): The directory to search in

Returns:
    list[str]: A list of files found in the directory

Example:

```python
from autogpt.commands.file_operations import search_files

search_files(...)
```

#### `download_file(url, filename)`

Downloads a file
Args:
    url (str): URL of the file to download
    filename (str): Filename to save the file as

Example:

```python
from autogpt.commands.file_operations import download_file

download_file(...)
```

---

## Module: `autogpt.commands.git_operations`

Git operations for autogpt

### Functions

#### `clone_repository(repository_url: str, clone_path: str)`

Clone a GitHub repository locally.

Args:
    repository_url (str): The URL of the repository to clone.
    clone_path (str): The path to clone the repository to.

Returns:
    str: The result of the clone operation.

Example:

```python
from autogpt.commands.git_operations import clone_repository

clone_repository(...)
```

---

## Module: `autogpt.commands.google_search`

Google search command for Autogpt.

### Functions

#### `google_search(query: str, num_results: int=8)`

Return the results of a Google search

Args:
    query (str): The search query.
    num_results (int): The number of results to return.

Returns:
    str: The results of the search.

Example:

```python
from autogpt.commands.google_search import google_search

google_search(...)
```

#### `google_official_search(query: str, num_results: int=8)`

Return the results of a Google search using the official Google API

Args:
    query (str): The search query.
    num_results (int): The number of results to return.

Returns:
    str: The results of the search.

Example:

```python
from autogpt.commands.google_search import google_official_search

google_official_search(...)
```

#### `safe_google_results(results: str | list)`

Return the results of a google search in a safe format.

Args:
    results (str | list): The search results.

Returns:
    str: The results of the search.

Example:

```python
from autogpt.commands.google_search import safe_google_results

safe_google_results(...)
```

---

## Module: `autogpt.commands.image_gen`

Image Generation Module for AutoGPT.

### Functions

#### `generate_image(prompt: str, size: int=256)`

Generate an image from a prompt.

Args:
    prompt (str): The prompt to use
    size (int, optional): The size of the image. Defaults to 256. (Not supported by HuggingFace)

Returns:
    str: The filename of the image

Example:

```python
from autogpt.commands.image_gen import generate_image

generate_image(...)
```

#### `generate_image_with_hf(prompt: str, filename: str)`

Generate an image with HuggingFace's API.

Args:
    prompt (str): The prompt to use
    filename (str): The filename to save the image to

Returns:
    str: The filename of the image

Example:

```python
from autogpt.commands.image_gen import generate_image_with_hf

generate_image_with_hf(...)
```

#### `generate_image_with_dalle(prompt: str, filename: str, size: int)`

Generate an image with DALL-E.

Args:
    prompt (str): The prompt to use
    filename (str): The filename to save the image to
    size (int): The size of the image

Returns:
    str: The filename of the image

Example:

```python
from autogpt.commands.image_gen import generate_image_with_dalle

generate_image_with_dalle(...)
```

#### `generate_image_with_sd_webui(prompt: str, filename: str, size: int=512, negative_prompt: str='', extra: dict={})`

Generate an image with Stable Diffusion webui.
Args:
    prompt (str): The prompt to use
    filename (str): The filename to save the image to
    size (int, optional): The size of the image. Defaults to 256.
    negative_prompt (str, optional): The negative prompt to use. Defaults to "".
    extra (dict, optional): Extra parameters to pass to the API. Defaults to {}.
Returns:
    str: The filename of the image

Example:

```python
from autogpt.commands.image_gen import generate_image_with_sd_webui

generate_image_with_sd_webui(...)
```

---

## Module: `autogpt.commands.improve_code`

No description available.

### Functions

#### `improve_code(suggestions: list[str], code: str)`

A function that takes in code and suggestions and returns a response from create
  chat completion api call.

Parameters:
    suggestions (list): A list of suggestions around what needs to be improved.
    code (str): Code to be improved.
Returns:
    A result string from create chat completion. Improved code in response.

Example:

```python
from autogpt.commands.improve_code import improve_code

improve_code(...)
```

---

## Module: `autogpt.commands.times`

No description available.

### Functions

#### `get_datetime()`

Return the current date and time

Returns:
    str: The current date and time

Example:

```python
from autogpt.commands.times import get_datetime

get_datetime(...)
```

---

## Module: `autogpt.commands.twitter`

A module that contains a command to send a tweet.

### Functions

#### `send_tweet(tweet_text: str)`

A function that takes in a string and returns a response from create chat
    completion api call.

Args:
  tweet_text (str): Text to be tweeted.

  Returns:
      A result from sending the tweet.

Example:

```python
from autogpt.commands.twitter import send_tweet

send_tweet(...)
```

---

## Module: `autogpt.commands.web_playwright`

Web scraping commands using Playwright

### Functions

#### `scrape_text(url: str)`

Scrape text from a webpage

Args:
    url (str): The URL to scrape text from

Returns:
    str: The scraped text

Example:

```python
from autogpt.commands.web_playwright import scrape_text

scrape_text(...)
```

#### `scrape_links(url: str)`

Scrape links from a webpage

Args:
    url (str): The URL to scrape links from

Returns:
    Union[str, List[str]]: The scraped links

Example:

```python
from autogpt.commands.web_playwright import scrape_links

scrape_links(...)
```

---

## Module: `autogpt.commands.web_requests`

Browse a webpage and summarize it using the LLM model

### Functions

#### `get_response(url: str, timeout: int=10)`

Get the response from a URL

Args:
    url (str): The URL to get the response from
    timeout (int): The timeout for the HTTP request

Returns:
    tuple[None, str] | tuple[Response, None]: The response and error message

Raises:
    ValueError: If the URL is invalid
    requests.exceptions.RequestException: If the HTTP request fails

Example:

```python
from autogpt.commands.web_requests import get_response

get_response(...)
```

#### `scrape_text(url: str)`

Scrape text from a webpage

Args:
    url (str): The URL to scrape text from

Returns:
    str: The scraped text

Example:

```python
from autogpt.commands.web_requests import scrape_text

scrape_text(...)
```

#### `scrape_links(url: str)`

Scrape links from a webpage

Args:
    url (str): The URL to scrape links from

Returns:
   str | list[str]: The scraped links

Example:

```python
from autogpt.commands.web_requests import scrape_links

scrape_links(...)
```

#### `create_message(chunk, question)`

Create a message for the user to summarize a chunk of text

Example:

```python
from autogpt.commands.web_requests import create_message

create_message(...)
```

---

## Module: `autogpt.commands.web_selenium`

Selenium web scraping module.

### Functions

#### `browse_website(url: str, question: str)`

Browse a website and return the answer and links to the user

Args:
    url (str): The url of the website to browse
    question (str): The question asked by the user

Returns:
    Tuple[str, WebDriver]: The answer and links to the user and the webdriver

Example:

```python
from autogpt.commands.web_selenium import browse_website

browse_website(...)
```

#### `scrape_text_with_selenium(url: str)`

Scrape text from a website using selenium

Args:
    url (str): The url of the website to scrape

Returns:
    Tuple[WebDriver, str]: The webdriver and the text scraped from the website

Example:

```python
from autogpt.commands.web_selenium import scrape_text_with_selenium

scrape_text_with_selenium(...)
```

#### `scrape_links_with_selenium(driver: WebDriver, url: str)`

Scrape links from a website using selenium

Args:
    driver (WebDriver): The webdriver to use to scrape the links

Returns:
    List[str]: The links scraped from the website

Example:

```python
from autogpt.commands.web_selenium import scrape_links_with_selenium

scrape_links_with_selenium(...)
```

#### `close_browser(driver: WebDriver)`

Close the browser

Args:
    driver (WebDriver): The webdriver to close

Returns:
    None

Example:

```python
from autogpt.commands.web_selenium import close_browser

close_browser(...)
```

#### `add_header(driver: WebDriver)`

Add a header to the website

Args:
    driver (WebDriver): The webdriver to use to add the header

Returns:
    None

Example:

```python
from autogpt.commands.web_selenium import add_header

add_header(...)
```

---

## Module: `autogpt.commands.write_tests`

A module that contains a function to generate test cases for the submitted code.

### Functions

#### `write_tests(code: str, focus: list[str])`

A function that takes in code and focus topics and returns a response from create
  chat completion api call.

Parameters:
    focus (list): A list of suggestions around what needs to be improved.
    code (str): Code for test cases to be generated against.
Returns:
    A result string from create chat completion. Test cases for the submitted code
      in response.

Example:

```python
from autogpt.commands.write_tests import write_tests

write_tests(...)
```

---

## Module: `autogpt.config.__init__`

This module contains the configuration classes for AutoGPT.

---

## Module: `autogpt.config.ai_config`

A module that contains the AIConfig class object that contains the configuration

### Classes

#### `AIConfig`

A class object that contains the configuration information for the AI

Attributes:
    ai_name (str): The name of the AI.
    ai_role (str): The description of the AI's role.
    ai_goals (list): The list of objectives the AI is supposed to complete.
    api_budget (float): The maximum dollar value for API calls (0.0 means infinite)

Example:

```python
from autogpt.config.ai_config import AIConfig

aIConfig = AIConfig(...)
```

##### Methods

- `load(config_file: str=SAVE_FILE)`: Returns class object with parameters (ai_name, ai_role, ai_goals, api_budget) loaded from
  yaml file if yaml file exists,
else returns class with no parameters.

Parameters:
   config_file (int): The path to the config yaml file.
     DEFAULT: "../ai_settings.yaml"

Returns:
    cls (object): An instance of given cls object

  Example:

```python
aIConfig = AIConfig(...)
aIConfig.load(...)
```

- `save(self, config_file: str=SAVE_FILE)`: Saves the class parameters to the specified file yaml file path as a yaml file.

Parameters:
    config_file(str): The path to the config yaml file.
      DEFAULT: "../ai_settings.yaml"

Returns:
    None

  Example:

```python
aIConfig = AIConfig(...)
aIConfig.save(...)
```

- `construct_full_prompt(self, prompt_generator: Optional[PromptGenerator]=None)`: Returns a prompt to the user with the class information in an organized fashion.

Parameters:
    None

Returns:
    full_prompt (str): A string containing the initial prompt for the user
      including the ai_name, ai_role, ai_goals, and api_budget.

  Example:

```python
aIConfig = AIConfig(...)
aIConfig.construct_full_prompt(...)
```

---

## Module: `autogpt.config.config`

Configuration class to store the state of bools for different scripts access.

### Functions

#### `check_openai_api_key()`

Check if the OpenAI API key is set in config.py or as an environment variable.

Example:

```python
from autogpt.config.config import check_openai_api_key

check_openai_api_key(...)
```

### Classes

#### `Config`

Configuration class to store the state of bools for different scripts access.

Example:

```python
from autogpt.config.config import Config

config = Config(...)
```

##### Methods

- `get_azure_deployment_id_for_model(self, model: str)`: Returns the relevant deployment id for the model specified.

Parameters:
    model(str): The model to map to the deployment id.

Returns:
    The matching deployment id if found, otherwise an empty string.

  Example:

```python
config = Config(...)
config.get_azure_deployment_id_for_model(...)
```

- `load_azure_config(self, config_file: str=AZURE_CONFIG_FILE)`: Loads the configuration parameters for Azure hosting from the specified file
  path as a yaml file.

Parameters:
    config_file(str): The path to the config yaml file. DEFAULT: "../azure.yaml"

Returns:
    None

  Example:

```python
config = Config(...)
config.load_azure_config(...)
```

- `set_continuous_mode(self, value: bool)`: Set the continuous mode value.

  Example:

```python
config = Config(...)
config.set_continuous_mode(...)
```

- `set_continuous_limit(self, value: int)`: Set the continuous limit value.

  Example:

```python
config = Config(...)
config.set_continuous_limit(...)
```

- `set_speak_mode(self, value: bool)`: Set the speak mode value.

  Example:

```python
config = Config(...)
config.set_speak_mode(...)
```

- `set_fast_llm_model(self, value: str)`: Set the fast LLM model value.

  Example:

```python
config = Config(...)
config.set_fast_llm_model(...)
```

- `set_smart_llm_model(self, value: str)`: Set the smart LLM model value.

  Example:

```python
config = Config(...)
config.set_smart_llm_model(...)
```

- `set_fast_token_limit(self, value: int)`: Set the fast token limit value.

  Example:

```python
config = Config(...)
config.set_fast_token_limit(...)
```

- `set_smart_token_limit(self, value: int)`: Set the smart token limit value.

  Example:

```python
config = Config(...)
config.set_smart_token_limit(...)
```

- `set_browse_chunk_max_length(self, value: int)`: Set the browse_website command chunk max length value.

  Example:

```python
config = Config(...)
config.set_browse_chunk_max_length(...)
```

- `set_openai_api_key(self, value: str)`: Set the OpenAI API key value.

  Example:

```python
config = Config(...)
config.set_openai_api_key(...)
```

- `set_elevenlabs_api_key(self, value: str)`: Set the ElevenLabs API key value.

  Example:

```python
config = Config(...)
config.set_elevenlabs_api_key(...)
```

- `set_elevenlabs_voice_1_id(self, value: str)`: Set the ElevenLabs Voice 1 ID value.

  Example:

```python
config = Config(...)
config.set_elevenlabs_voice_1_id(...)
```

- `set_elevenlabs_voice_2_id(self, value: str)`: Set the ElevenLabs Voice 2 ID value.

  Example:

```python
config = Config(...)
config.set_elevenlabs_voice_2_id(...)
```

- `set_google_api_key(self, value: str)`: Set the Google API key value.

  Example:

```python
config = Config(...)
config.set_google_api_key(...)
```

- `set_custom_search_engine_id(self, value: str)`: Set the custom search engine id value.

  Example:

```python
config = Config(...)
config.set_custom_search_engine_id(...)
```

- `set_pinecone_api_key(self, value: str)`: Set the Pinecone API key value.

  Example:

```python
config = Config(...)
config.set_pinecone_api_key(...)
```

- `set_pinecone_region(self, value: str)`: Set the Pinecone region value.

  Example:

```python
config = Config(...)
config.set_pinecone_region(...)
```

- `set_debug_mode(self, value: bool)`: Set the debug mode value.

  Example:

```python
config = Config(...)
config.set_debug_mode(...)
```

- `set_plugins(self, value: list)`: Set the plugins value.

  Example:

```python
config = Config(...)
config.set_plugins(...)
```

- `set_temperature(self, value: int)`: Set the temperature value.

  Example:

```python
config = Config(...)
config.set_temperature(...)
```

- `set_memory_backend(self, name: str)`: Set the memory backend name.

  Example:

```python
config = Config(...)
config.set_memory_backend(...)
```

---

## Module: `autogpt.configurator`

Configurator module.

### Functions

#### `create_config(continuous: bool, continuous_limit: int, ai_settings_file: str, skip_reprompt: bool, speak: bool, debug: bool, gpt3only: bool, gpt4only: bool, memory_type: str, browser_name: str, allow_downloads: bool, skip_news: bool)`

Updates the config object with the given arguments.

Args:
    continuous (bool): Whether to run in continuous mode
    continuous_limit (int): The number of times to run in continuous mode
    ai_settings_file (str): The path to the ai_settings.yaml file
    skip_reprompt (bool): Whether to skip the re-prompting messages at the beginning of the script
    speak (bool): Whether to enable speak mode
    debug (bool): Whether to enable debug mode
    gpt3only (bool): Whether to enable GPT3.5 only mode
    gpt4only (bool): Whether to enable GPT4 only mode
    memory_type (str): The type of memory backend to use
    browser_name (str): The name of the browser to use when using selenium to scrape the web
    allow_downloads (bool): Whether to allow Auto-GPT to download files natively
    skips_news (bool): Whether to suppress the output of latest news on startup

Example:

```python
from autogpt.configurator import create_config

create_config(...)
```

---

## Module: `autogpt.json_utils.__init__`

No description available.

---

## Module: `autogpt.json_utils.json_fix_general`

This module contains functions to fix JSON strings using general programmatic approaches, suitable for addressing
common JSON formatting issues.

### Functions

#### `fix_invalid_escape(json_to_load: str, error_message: str)`

Fix invalid escape sequences in JSON strings.

Args:
    json_to_load (str): The JSON string.
    error_message (str): The error message from the JSONDecodeError
      exception.

Returns:
    str: The JSON string with invalid escape sequences fixed.

Example:

```python
from autogpt.json_utils.json_fix_general import fix_invalid_escape

fix_invalid_escape(...)
```

#### `balance_braces(json_string: str)`

Balance the braces in a JSON string.

Args:
    json_string (str): The JSON string.

Returns:
    str: The JSON string with braces balanced.

Example:

```python
from autogpt.json_utils.json_fix_general import balance_braces

balance_braces(...)
```

#### `add_quotes_to_property_names(json_string: str)`

Add quotes to property names in a JSON string.

Args:
    json_string (str): The JSON string.

Returns:
    str: The JSON string with quotes added to property names.

Example:

```python
from autogpt.json_utils.json_fix_general import add_quotes_to_property_names

add_quotes_to_property_names(...)
```

#### `correct_json(json_to_load: str)`

Correct common JSON errors.
Args:
    json_to_load (str): The JSON string.

Example:

```python
from autogpt.json_utils.json_fix_general import correct_json

correct_json(...)
```

---

## Module: `autogpt.json_utils.json_fix_llm`

This module contains functions to fix JSON strings generated by LLM models, such as ChatGPT, using the assistance
of the ChatGPT API or LLM models.

### Functions

#### `auto_fix_json(json_string: str, schema: str)`

Fix the given JSON string to make it parseable and fully compliant with
    the provided schema using GPT-3.

Args:
    json_string (str): The JSON string to fix.
    schema (str): The schema to use to fix the JSON.
Returns:
    str: The fixed JSON string.

Example:

```python
from autogpt.json_utils.json_fix_llm import auto_fix_json

auto_fix_json(...)
```

#### `fix_json_using_multiple_techniques(assistant_reply: str)`

Fix the given JSON string to make it parseable and fully compliant with two techniques.

Args:
    json_string (str): The JSON string to fix.

Returns:
    str: The fixed JSON string.

Example:

```python
from autogpt.json_utils.json_fix_llm import fix_json_using_multiple_techniques

fix_json_using_multiple_techniques(...)
```

#### `fix_and_parse_json(json_to_load: str, try_to_fix_with_gpt: bool=True)`

Fix and parse JSON string

Args:
    json_to_load (str): The JSON string.
    try_to_fix_with_gpt (bool, optional): Try to fix the JSON with GPT.
        Defaults to True.

Returns:
    str or dict[Any, Any]: The parsed JSON.

Example:

```python
from autogpt.json_utils.json_fix_llm import fix_and_parse_json

fix_and_parse_json(...)
```

#### `try_ai_fix(try_to_fix_with_gpt: bool, exception: Exception, json_to_load: str)`

Try to fix the JSON with the AI

Args:
    try_to_fix_with_gpt (bool): Whether to try to fix the JSON with the AI.
    exception (Exception): The exception that was raised.
    json_to_load (str): The JSON string to load.

Raises:
    exception: If try_to_fix_with_gpt is False.

Returns:
    str or dict[Any, Any]: The JSON string or dictionary.

Example:

```python
from autogpt.json_utils.json_fix_llm import try_ai_fix

try_ai_fix(...)
```

#### `attempt_to_fix_json_by_finding_outermost_brackets(json_string: str)`

No description available.

Example:

```python
from autogpt.json_utils.json_fix_llm import attempt_to_fix_json_by_finding_outermost_brackets

attempt_to_fix_json_by_finding_outermost_brackets(...)
```

---

## Module: `autogpt.json_utils.utilities`

Utilities for the json_fixes package.

### Functions

#### `extract_char_position(error_message: str)`

Extract the character position from the JSONDecodeError message.

Args:
    error_message (str): The error message from the JSONDecodeError
      exception.

Returns:
    int: The character position.

Example:

```python
from autogpt.json_utils.utilities import extract_char_position

extract_char_position(...)
```

#### `validate_json(json_object: object, schema_name: object)`

:type schema_name: object
:param schema_name:
:type json_object: object

Example:

```python
from autogpt.json_utils.utilities import validate_json

validate_json(...)
```

---

## Module: `autogpt.llm_utils`

No description available.

### Functions

#### `retry_openai_api(num_retries: int=10, backoff_base: float=2.0, warn_user: bool=True)`

Retry an OpenAI API call.

Args:
    num_retries int: Number of retries. Defaults to 10.
    backoff_base float: Base for exponential backoff. Defaults to 2.
    warn_user bool: Whether to warn the user. Defaults to True.

Example:

```python
from autogpt.llm_utils import retry_openai_api

retry_openai_api(...)
```

#### `call_ai_function(function: str, args: list, description: str, model: str | None=None)`

Call an AI function

This is a magic function that can do anything with no-code. See
https://github.com/Torantulino/AI-Functions for more info.

Args:
    function (str): The function to call
    args (list): The arguments to pass to the function
    description (str): The description of the function
    model (str, optional): The model to use. Defaults to None.

Returns:
    str: The response from the function

Example:

```python
from autogpt.llm_utils import call_ai_function

call_ai_function(...)
```

#### `create_chat_completion(messages: List[Message], model: Optional[str]=None, temperature: float=None, max_tokens: Optional[int]=None)`

Create a chat completion using the OpenAI API

Args:
    messages (List[Message]): The messages to send to the chat completion
    model (str, optional): The model to use. Defaults to None.
    temperature (float, optional): The temperature to use. Defaults to 0.9.
    max_tokens (int, optional): The max tokens to use. Defaults to None.

Returns:
    str: The response from the chat completion

Example:

```python
from autogpt.llm_utils import create_chat_completion

create_chat_completion(...)
```

#### `get_ada_embedding(text: str)`

Get an embedding from the ada model.

Args:
    text (str): The text to embed.

Returns:
    List[float]: The embedding.

Example:

```python
from autogpt.llm_utils import get_ada_embedding

get_ada_embedding(...)
```

#### `create_embedding(text: str, *_, **kwargs)`

Create an embedding using the OpenAI API

Args:
    text (str): The text to embed.
    kwargs: Other arguments to pass to the OpenAI API embedding creation call.

Returns:
    openai.Embedding: The embedding object.

Example:

```python
from autogpt.llm_utils import create_embedding

create_embedding(...)
```

---

## Module: `autogpt.logs`

Logging module for Auto-GPT.

### Functions

#### `remove_color_codes(s: str)`

No description available.

Example:

```python
from autogpt.logs import remove_color_codes

remove_color_codes(...)
```

#### `print_assistant_thoughts(ai_name: object, assistant_reply_json_valid: object, speak_mode: bool=False)`

No description available.

Example:

```python
from autogpt.logs import print_assistant_thoughts

print_assistant_thoughts(...)
```

### Classes

#### `Logger`

Logger that handle titles in different colors.
Outputs logs in console, activity.log, and errors.log
For console handler: simulates typing

Example:

```python
from autogpt.logs import Logger

logger = Logger(...)
```

##### Methods

- `typewriter_log(self, title='', title_color='', content='', speak_text=False, level=logging.INFO)`: No description available.

  Example:

```python
logger = Logger(...)
logger.typewriter_log(...)
```

- `debug(self, message, title='', title_color='')`: No description available.

  Example:

```python
logger = Logger(...)
logger.debug(...)
```

- `warn(self, message, title='', title_color='')`: No description available.

  Example:

```python
logger = Logger(...)
logger.warn(...)
```

- `error(self, title, message='')`: No description available.

  Example:

```python
logger = Logger(...)
logger.error(...)
```

- `set_level(self, level)`: No description available.

  Example:

```python
logger = Logger(...)
logger.set_level(...)
```

- `double_check(self, additionalText=None)`: No description available.

  Example:

```python
logger = Logger(...)
logger.double_check(...)
```

#### `TypingConsoleHandler`

No description available.

Example:

```python
from autogpt.logs import TypingConsoleHandler

typingConsoleHandler = TypingConsoleHandler(...)
```

##### Methods

- `emit(self, record)`: No description available.

  Example:

```python
typingConsoleHandler = TypingConsoleHandler(...)
typingConsoleHandler.emit(...)
```

#### `ConsoleHandler`

No description available.

Example:

```python
from autogpt.logs import ConsoleHandler

consoleHandler = ConsoleHandler(...)
```

##### Methods

- `emit(self, record)`: No description available.

  Example:

```python
consoleHandler = ConsoleHandler(...)
consoleHandler.emit(...)
```

#### `AutoGptFormatter`

Allows to handle custom placeholders 'title_color' and 'message_no_color'.
To use this formatter, make sure to pass 'color', 'title' as log extras.

Example:

```python
from autogpt.logs import AutoGptFormatter

autoGptFormatter = AutoGptFormatter(...)
```

##### Methods

- `format(self, record: LogRecord)`: No description available.

  Example:

```python
autoGptFormatter = AutoGptFormatter(...)
autoGptFormatter.format(...)
```

---

## Module: `autogpt.main`

The application entry point.  Can be invoked by a CLI or any other front end application.

### Functions

#### `run_auto_gpt(continuous: bool, continuous_limit: int, ai_settings: str, skip_reprompt: bool, speak: bool, debug: bool, gpt3only: bool, gpt4only: bool, memory_type: str, browser_name: str, allow_downloads: bool, skip_news: bool, workspace_directory: str, install_plugin_deps: bool)`

No description available.

Example:

```python
from autogpt.main import run_auto_gpt

run_auto_gpt(...)
```

---

## Module: `autogpt.memory.__init__`

No description available.

### Functions

#### `get_memory(cfg, init=False)`

No description available.

Example:

```python
from autogpt.memory.__init__ import get_memory

get_memory(...)
```

#### `get_supported_memory_backends()`

No description available.

Example:

```python
from autogpt.memory.__init__ import get_supported_memory_backends

get_supported_memory_backends(...)
```

---

## Module: `autogpt.memory.base`

Base class for memory providers.

### Classes

#### `MemoryProviderSingleton`

No description available.

Example:

```python
from autogpt.memory.base import MemoryProviderSingleton

memoryProviderSingleton = MemoryProviderSingleton(...)
```

##### Methods

- `add(self, data)`: Adds to memory

  Example:

```python
memoryProviderSingleton = MemoryProviderSingleton(...)
memoryProviderSingleton.add(...)
```

- `get(self, data)`: Gets from memory

  Example:

```python
memoryProviderSingleton = MemoryProviderSingleton(...)
memoryProviderSingleton.get(...)
```

- `clear(self)`: Clears memory

  Example:

```python
memoryProviderSingleton = MemoryProviderSingleton(...)
memoryProviderSingleton.clear(...)
```

- `get_relevant(self, data, num_relevant=5)`: Gets relevant memory for

  Example:

```python
memoryProviderSingleton = MemoryProviderSingleton(...)
memoryProviderSingleton.get_relevant(...)
```

- `get_stats(self)`: Get stats from memory

  Example:

```python
memoryProviderSingleton = MemoryProviderSingleton(...)
memoryProviderSingleton.get_stats(...)
```

---

## Module: `autogpt.memory.local`

No description available.

### Functions

#### `create_default_embeddings()`

No description available.

Example:

```python
from autogpt.memory.local import create_default_embeddings

create_default_embeddings(...)
```

### Classes

#### `CacheContent`

No description available.

Example:

```python
from autogpt.memory.local import CacheContent

cacheContent = CacheContent(...)
```

#### `LocalCache`

A class that stores the memory in a local file

Example:

```python
from autogpt.memory.local import LocalCache

localCache = LocalCache(...)
```

##### Methods

- `add(self, text: str)`: Add text to our list of texts, add embedding as row to our
    embeddings-matrix

Args:
    text: str

Returns: None

  Example:

```python
localCache = LocalCache(...)
localCache.add(...)
```

- `clear(self)`: Clears the data in memory.

Returns: A message indicating that the memory has been cleared.

  Example:

```python
localCache = LocalCache(...)
localCache.clear(...)
```

- `get(self, data: str)`: Gets the data from the memory that is most relevant to the given data.

Args:
    data: The data to compare to.

Returns: The most relevant data.

  Example:

```python
localCache = LocalCache(...)
localCache.get(...)
```

- `get_relevant(self, text: str, k: int)`: "
matrix-vector mult to find score-for-each-row-of-matrix
 get indices for top-k winning scores
 return texts for those indices
Args:
    text: str
    k: int

Returns: List[str]

  Example:

```python
localCache = LocalCache(...)
localCache.get_relevant(...)
```

- `get_stats(self)`: Returns: The stats of the local cache.

  Example:

```python
localCache = LocalCache(...)
localCache.get_stats(...)
```

---

## Module: `autogpt.memory.milvus`

Milvus memory storage provider.

### Classes

#### `MilvusMemory`

Milvus memory storage provider.

Example:

```python
from autogpt.memory.milvus import MilvusMemory

milvusMemory = MilvusMemory(...)
```

##### Methods

- `configure(self, cfg: Config)`: No description available.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.configure(...)
```

- `init_collection(self)`: Initialize collection in vector database.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.init_collection(...)
```

- `add(self, data)`: Add an embedding of data into memory.

Args:
    data (str): The raw text to construct embedding index.

Returns:
    str: log.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.add(...)
```

- `get(self, data)`: Return the most relevant data in memory.
Args:
    data: The data to compare to.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.get(...)
```

- `clear(self)`: Drop the index in memory.

Returns:
    str: log.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.clear(...)
```

- `get_relevant(self, data: str, num_relevant: int=5)`: Return the top-k relevant data in memory.
Args:
    data: The data to compare to.
    num_relevant (int, optional): The max number of relevant data.
        Defaults to 5.

Returns:
    list: The top-k relevant data.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.get_relevant(...)
```

- `get_stats(self)`: Returns: The stats of the milvus cache.

  Example:

```python
milvusMemory = MilvusMemory(...)
milvusMemory.get_stats(...)
```

---

## Module: `autogpt.memory.no_memory`

A class that does not store any data. This is the default memory provider.

### Classes

#### `NoMemory`

A class that does not store any data. This is the default memory provider.

Example:

```python
from autogpt.memory.no_memory import NoMemory

noMemory = NoMemory(...)
```

##### Methods

- `add(self, data: str)`: Adds a data point to the memory. No action is taken in NoMemory.

Args:
    data: The data to add.

Returns: An empty string.

  Example:

```python
noMemory = NoMemory(...)
noMemory.add(...)
```

- `get(self, data: str)`: Gets the data from the memory that is most relevant to the given data.
NoMemory always returns None.

Args:
    data: The data to compare to.

Returns: None

  Example:

```python
noMemory = NoMemory(...)
noMemory.get(...)
```

- `clear(self)`: Clears the memory. No action is taken in NoMemory.

Returns: An empty string.

  Example:

```python
noMemory = NoMemory(...)
noMemory.clear(...)
```

- `get_relevant(self, data: str, num_relevant: int=5)`: Returns all the data in the memory that is relevant to the given data.
NoMemory always returns None.

Args:
    data: The data to compare to.
    num_relevant: The number of relevant data to return.

Returns: None

  Example:

```python
noMemory = NoMemory(...)
noMemory.get_relevant(...)
```

- `get_stats(self)`: Returns: An empty dictionary as there are no stats in NoMemory.

  Example:

```python
noMemory = NoMemory(...)
noMemory.get_stats(...)
```

---

## Module: `autogpt.memory.pinecone`

No description available.

### Classes

#### `PineconeMemory`

No description available.

Example:

```python
from autogpt.memory.pinecone import PineconeMemory

pineconeMemory = PineconeMemory(...)
```

##### Methods

- `add(self, data)`: No description available.

  Example:

```python
pineconeMemory = PineconeMemory(...)
pineconeMemory.add(...)
```

- `get(self, data)`: No description available.

  Example:

```python
pineconeMemory = PineconeMemory(...)
pineconeMemory.get(...)
```

- `clear(self)`: No description available.

  Example:

```python
pineconeMemory = PineconeMemory(...)
pineconeMemory.clear(...)
```

- `get_relevant(self, data, num_relevant=5)`: Returns all the data in the memory that is relevant to the given data.
:param data: The data to compare to.
:param num_relevant: The number of relevant data to return. Defaults to 5

  Example:

```python
pineconeMemory = PineconeMemory(...)
pineconeMemory.get_relevant(...)
```

- `get_stats(self)`: No description available.

  Example:

```python
pineconeMemory = PineconeMemory(...)
pineconeMemory.get_stats(...)
```

---

## Module: `autogpt.memory.redismem`

Redis memory provider.

### Classes

#### `RedisMemory`

No description available.

Example:

```python
from autogpt.memory.redismem import RedisMemory

redisMemory = RedisMemory(...)
```

##### Methods

- `add(self, data: str)`: Adds a data point to the memory.

Args:
    data: The data to add.

Returns: Message indicating that the data has been added.

  Example:

```python
redisMemory = RedisMemory(...)
redisMemory.add(...)
```

- `get(self, data: str)`: Gets the data from the memory that is most relevant to the given data.

Args:
    data: The data to compare to.

Returns: The most relevant data.

  Example:

```python
redisMemory = RedisMemory(...)
redisMemory.get(...)
```

- `clear(self)`: Clears the redis server.

Returns: A message indicating that the memory has been cleared.

  Example:

```python
redisMemory = RedisMemory(...)
redisMemory.clear(...)
```

- `get_relevant(self, data: str, num_relevant: int=5)`: Returns all the data in the memory that is relevant to the given data.
Args:
    data: The data to compare to.
    num_relevant: The number of relevant data to return.

Returns: A list of the most relevant data.

  Example:

```python
redisMemory = RedisMemory(...)
redisMemory.get_relevant(...)
```

- `get_stats(self)`: Returns: The stats of the memory index.

  Example:

```python
redisMemory = RedisMemory(...)
redisMemory.get_stats(...)
```

---

## Module: `autogpt.memory.weaviate`

No description available.

### Functions

#### `default_schema(weaviate_index)`

No description available.

Example:

```python
from autogpt.memory.weaviate import default_schema

default_schema(...)
```

### Classes

#### `WeaviateMemory`

No description available.

Example:

```python
from autogpt.memory.weaviate import WeaviateMemory

weaviateMemory = WeaviateMemory(...)
```

##### Methods

- `format_classname(index)`: No description available.

  Example:

```python
weaviateMemory = WeaviateMemory(...)
weaviateMemory.format_classname(...)
```

- `add(self, data)`: No description available.

  Example:

```python
weaviateMemory = WeaviateMemory(...)
weaviateMemory.add(...)
```

- `get(self, data)`: No description available.

  Example:

```python
weaviateMemory = WeaviateMemory(...)
weaviateMemory.get(...)
```

- `clear(self)`: No description available.

  Example:

```python
weaviateMemory = WeaviateMemory(...)
weaviateMemory.clear(...)
```

- `get_relevant(self, data, num_relevant=5)`: No description available.

  Example:

```python
weaviateMemory = WeaviateMemory(...)
weaviateMemory.get_relevant(...)
```

- `get_stats(self)`: No description available.

  Example:

```python
weaviateMemory = WeaviateMemory(...)
weaviateMemory.get_stats(...)
```

---

## Module: `autogpt.models.base_open_ai_plugin`

Handles loading of plugins.

### Classes

#### `Message`

No description available.

Example:

```python
from autogpt.models.base_open_ai_plugin import Message

message = Message(...)
```

#### `BaseOpenAIPlugin`

This is a BaseOpenAIPlugin class for generating Auto-GPT plugins.

Example:

```python
from autogpt.models.base_open_ai_plugin import BaseOpenAIPlugin

baseOpenAIPlugin = BaseOpenAIPlugin(...)
```

##### Methods

- `can_handle_on_response(self)`: This method is called to check that the plugin can
handle the on_response method.
Returns:
    bool: True if the plugin can handle the on_response method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_on_response(...)
```

- `on_response(self, response: str, *args, **kwargs)`: This method is called when a response is received from the model.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.on_response(...)
```

- `can_handle_post_prompt(self)`: This method is called to check that the plugin can
handle the post_prompt method.
Returns:
    bool: True if the plugin can handle the post_prompt method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_post_prompt(...)
```

- `post_prompt(self, prompt: PromptGenerator)`: This method is called just after the generate_prompt is called,
    but actually before the prompt is generated.
Args:
    prompt (PromptGenerator): The prompt generator.
Returns:
    PromptGenerator: The prompt generator.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.post_prompt(...)
```

- `can_handle_on_planning(self)`: This method is called to check that the plugin can
handle the on_planning method.
Returns:
    bool: True if the plugin can handle the on_planning method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_on_planning(...)
```

- `on_planning(self, prompt: PromptGenerator, messages: List[Message])`: This method is called before the planning chat completion is done.
Args:
    prompt (PromptGenerator): The prompt generator.
    messages (List[str]): The list of messages.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.on_planning(...)
```

- `can_handle_post_planning(self)`: This method is called to check that the plugin can
handle the post_planning method.
Returns:
    bool: True if the plugin can handle the post_planning method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_post_planning(...)
```

- `post_planning(self, response: str)`: This method is called after the planning chat completion is done.
Args:
    response (str): The response.
Returns:
    str: The resulting response.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.post_planning(...)
```

- `can_handle_pre_instruction(self)`: This method is called to check that the plugin can
handle the pre_instruction method.
Returns:
    bool: True if the plugin can handle the pre_instruction method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_pre_instruction(...)
```

- `pre_instruction(self, messages: List[Message])`: This method is called before the instruction chat is done.
Args:
    messages (List[Message]): The list of context messages.
Returns:
    List[Message]: The resulting list of messages.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.pre_instruction(...)
```

- `can_handle_on_instruction(self)`: This method is called to check that the plugin can
handle the on_instruction method.
Returns:
    bool: True if the plugin can handle the on_instruction method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_on_instruction(...)
```

- `on_instruction(self, messages: List[Message])`: This method is called when the instruction chat is done.
Args:
    messages (List[Message]): The list of context messages.
Returns:
    Optional[str]: The resulting message.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.on_instruction(...)
```

- `can_handle_post_instruction(self)`: This method is called to check that the plugin can
handle the post_instruction method.
Returns:
    bool: True if the plugin can handle the post_instruction method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_post_instruction(...)
```

- `post_instruction(self, response: str)`: This method is called after the instruction chat is done.
Args:
    response (str): The response.
Returns:
    str: The resulting response.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.post_instruction(...)
```

- `can_handle_pre_command(self)`: This method is called to check that the plugin can
handle the pre_command method.
Returns:
    bool: True if the plugin can handle the pre_command method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_pre_command(...)
```

- `pre_command(self, command_name: str, arguments: Dict[str, Any])`: This method is called before the command is executed.
Args:
    command_name (str): The command name.
    arguments (Dict[str, Any]): The arguments.
Returns:
    Tuple[str, Dict[str, Any]]: The command name and the arguments.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.pre_command(...)
```

- `can_handle_post_command(self)`: This method is called to check that the plugin can
handle the post_command method.
Returns:
    bool: True if the plugin can handle the post_command method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_post_command(...)
```

- `post_command(self, command_name: str, response: str)`: This method is called after the command is executed.
Args:
    command_name (str): The command name.
    response (str): The response.
Returns:
    str: The resulting response.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.post_command(...)
```

- `can_handle_chat_completion(self, messages: Dict[Any, Any], model: str, temperature: float, max_tokens: int)`: This method is called to check that the plugin can
  handle the chat_completion method.
Args:
    messages (List[Message]): The messages.
    model (str): The model name.
    temperature (float): The temperature.
    max_tokens (int): The max tokens.
  Returns:
      bool: True if the plugin can handle the chat_completion method.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.can_handle_chat_completion(...)
```

- `handle_chat_completion(self, messages: List[Message], model: str, temperature: float, max_tokens: int)`: This method is called when the chat completion is done.
Args:
    messages (List[Message]): The messages.
    model (str): The model name.
    temperature (float): The temperature.
    max_tokens (int): The max tokens.
Returns:
    str: The resulting response.

  Example:

```python
baseOpenAIPlugin = BaseOpenAIPlugin(...)
baseOpenAIPlugin.handle_chat_completion(...)
```

---

## Module: `autogpt.modelsinfo`

No description available.

---

## Module: `autogpt.plugins`

Handles loading of plugins.

### Functions

#### `inspect_zip_for_modules(zip_path: str, debug: bool=False)`

Inspect a zipfile for a modules.

Args:
    zip_path (str): Path to the zipfile.
    debug (bool, optional): Enable debug logging. Defaults to False.

Returns:
    list[str]: The list of module names found or empty list if none were found.

Example:

```python
from autogpt.plugins import inspect_zip_for_modules

inspect_zip_for_modules(...)
```

#### `write_dict_to_json_file(data: dict, file_path: str)`

Write a dictionary to a JSON file.
Args:
    data (dict): Dictionary to write.
    file_path (str): Path to the file.

Example:

```python
from autogpt.plugins import write_dict_to_json_file

write_dict_to_json_file(...)
```

#### `fetch_openai_plugins_manifest_and_spec(cfg: Config)`

Fetch the manifest for a list of OpenAI plugins.
    Args:
    urls (List): List of URLs to fetch.
Returns:
    dict: per url dictionary of manifest and spec.

Example:

```python
from autogpt.plugins import fetch_openai_plugins_manifest_and_spec

fetch_openai_plugins_manifest_and_spec(...)
```

#### `create_directory_if_not_exists(directory_path: str)`

Create a directory if it does not exist.
Args:
    directory_path (str): Path to the directory.
Returns:
    bool: True if the directory was created, else False.

Example:

```python
from autogpt.plugins import create_directory_if_not_exists

create_directory_if_not_exists(...)
```

#### `initialize_openai_plugins(manifests_specs: dict, cfg: Config, debug: bool=False)`

Initialize OpenAI plugins.
Args:
    manifests_specs (dict): per url dictionary of manifest and spec.
    cfg (Config): Config instance including plugins config
    debug (bool, optional): Enable debug logging. Defaults to False.
Returns:
    dict: per url dictionary of manifest, spec and client.

Example:

```python
from autogpt.plugins import initialize_openai_plugins

initialize_openai_plugins(...)
```

#### `instantiate_openai_plugin_clients(manifests_specs_clients: dict, cfg: Config, debug: bool=False)`

Instantiates BaseOpenAIPlugin instances for each OpenAI plugin.
Args:
    manifests_specs_clients (dict): per url dictionary of manifest, spec and client.
    cfg (Config): Config instance including plugins config
    debug (bool, optional): Enable debug logging. Defaults to False.
Returns:
      plugins (dict): per url dictionary of BaseOpenAIPlugin instances.

Example:

```python
from autogpt.plugins import instantiate_openai_plugin_clients

instantiate_openai_plugin_clients(...)
```

#### `scan_plugins(cfg: Config, debug: bool=False)`

Scan the plugins directory for plugins and loads them.

Args:
    cfg (Config): Config instance including plugins config
    debug (bool, optional): Enable debug logging. Defaults to False.

Returns:
    List[Tuple[str, Path]]: List of plugins.

Example:

```python
from autogpt.plugins import scan_plugins

scan_plugins(...)
```

#### `denylist_allowlist_check(plugin_name: str, cfg: Config)`

Check if the plugin is in the allowlist or denylist.

Args:
    plugin_name (str): Name of the plugin.
    cfg (Config): Config object.

Returns:
    True or False

Example:

```python
from autogpt.plugins import denylist_allowlist_check

denylist_allowlist_check(...)
```

---

## Module: `autogpt.processing.__init__`

No description available.

---

## Module: `autogpt.processing.html`

HTML processing functions

### Functions

#### `extract_hyperlinks(soup: BeautifulSoup, base_url: str)`

Extract hyperlinks from a BeautifulSoup object

Args:
    soup (BeautifulSoup): The BeautifulSoup object
    base_url (str): The base URL

Returns:
    List[Tuple[str, str]]: The extracted hyperlinks

Example:

```python
from autogpt.processing.html import extract_hyperlinks

extract_hyperlinks(...)
```

#### `format_hyperlinks(hyperlinks: list[tuple[str, str]])`

Format hyperlinks to be displayed to the user

Args:
    hyperlinks (List[Tuple[str, str]]): The hyperlinks to format

Returns:
    List[str]: The formatted hyperlinks

Example:

```python
from autogpt.processing.html import format_hyperlinks

format_hyperlinks(...)
```

---

## Module: `autogpt.processing.text`

Text processing functions

### Functions

#### `split_text(text: str, max_length: int=CFG.browse_chunk_max_length, model: str=CFG.fast_llm_model, question: str='')`

Split text into chunks of a maximum length

Args:
    text (str): The text to split
    max_length (int, optional): The maximum length of each chunk. Defaults to 8192.

Yields:
    str: The next chunk of text

Raises:
    ValueError: If the text is longer than the maximum length

Example:

```python
from autogpt.processing.text import split_text

split_text(...)
```

#### `token_usage_of_chunk(messages, model)`

No description available.

Example:

```python
from autogpt.processing.text import token_usage_of_chunk

token_usage_of_chunk(...)
```

#### `summarize_text(url: str, text: str, question: str, driver: Optional[WebDriver]=None)`

Summarize text using the OpenAI API

Args:
    url (str): The url of the text
    text (str): The text to summarize
    question (str): The question to ask the model
    driver (WebDriver): The webdriver to use to scroll the page

Returns:
    str: The summary of the text

Example:

```python
from autogpt.processing.text import summarize_text

summarize_text(...)
```

#### `scroll_to_percentage(driver: WebDriver, ratio: float)`

Scroll to a percentage of the page

Args:
    driver (WebDriver): The webdriver to use
    ratio (float): The percentage to scroll to

Raises:
    ValueError: If the ratio is not between 0 and 1

Example:

```python
from autogpt.processing.text import scroll_to_percentage

scroll_to_percentage(...)
```

#### `create_message(chunk: str, question: str)`

Create a message for the chat completion

Args:
    chunk (str): The chunk of text to summarize
    question (str): The question to answer

Returns:
    Dict[str, str]: The message to send to the chat completion

Example:

```python
from autogpt.processing.text import create_message

create_message(...)
```

---

## Module: `autogpt.prompts.__init__`

No description available.

---

## Module: `autogpt.prompts.generator`

A module for generating custom prompt strings.

### Classes

#### `PromptGenerator`

A class for generating custom prompt strings based on constraints, commands,
resources, and performance evaluations.

Example:

```python
from autogpt.prompts.generator import PromptGenerator

promptGenerator = PromptGenerator(...)
```

##### Methods

- `add_constraint(self, constraint: str)`: Add a constraint to the constraints list.

Args:
    constraint (str): The constraint to be added.

  Example:

```python
promptGenerator = PromptGenerator(...)
promptGenerator.add_constraint(...)
```

- `add_command(self, command_label: str, command_name: str, args=None, function: Optional[Callable]=None)`: Add a command to the commands list with a label, name, and optional arguments.

Args:
    command_label (str): The label of the command.
    command_name (str): The name of the command.
    args (dict, optional): A dictionary containing argument names and their
      values. Defaults to None.
    function (callable, optional): A callable function to be called when
        the command is executed. Defaults to None.

  Example:

```python
promptGenerator = PromptGenerator(...)
promptGenerator.add_command(...)
```

- `add_resource(self, resource: str)`: Add a resource to the resources list.

Args:
    resource (str): The resource to be added.

  Example:

```python
promptGenerator = PromptGenerator(...)
promptGenerator.add_resource(...)
```

- `add_performance_evaluation(self, evaluation: str)`: Add a performance evaluation item to the performance_evaluation list.

Args:
    evaluation (str): The evaluation item to be added.

  Example:

```python
promptGenerator = PromptGenerator(...)
promptGenerator.add_performance_evaluation(...)
```

- `generate_prompt_string(self)`: Generate a prompt string based on the constraints, commands, resources,
    and performance evaluations.

Returns:
    str: The generated prompt string.

  Example:

```python
promptGenerator = PromptGenerator(...)
promptGenerator.generate_prompt_string(...)
```

---

## Module: `autogpt.prompts.prompt`

No description available.

### Functions

#### `build_default_prompt_generator()`

This function generates a prompt string that includes various constraints,
    commands, resources, and performance evaluations.

Returns:
    str: The generated prompt string.

Example:

```python
from autogpt.prompts.prompt import build_default_prompt_generator

build_default_prompt_generator(...)
```

#### `construct_main_ai_config()`

Construct the prompt for the AI to respond to

Returns:
    str: The prompt string

Example:

```python
from autogpt.prompts.prompt import construct_main_ai_config

construct_main_ai_config(...)
```

---

## Module: `autogpt.setup`

Set up the AI and its goals

### Functions

#### `prompt_user()`

Prompt the user for input

Returns:
    AIConfig: The AIConfig object tailored to the user's input

Example:

```python
from autogpt.setup import prompt_user

prompt_user(...)
```

#### `generate_aiconfig_manual()`

Interactively create an AI configuration by prompting the user to provide the name, role, and goals of the AI.

This function guides the user through a series of prompts to collect the necessary information to create
an AIConfig object. The user will be asked to provide a name and role for the AI, as well as up to five
goals. If the user does not provide a value for any of the fields, default values will be used.

Returns:
    AIConfig: An AIConfig object containing the user-defined or default AI name, role, and goals.

Example:

```python
from autogpt.setup import generate_aiconfig_manual

generate_aiconfig_manual(...)
```

#### `generate_aiconfig_automatic(user_prompt)`

Generates an AIConfig object from the given string.

Returns:
AIConfig: The AIConfig object tailored to the user's input

Example:

```python
from autogpt.setup import generate_aiconfig_automatic

generate_aiconfig_automatic(...)
```

---

## Module: `autogpt.singleton`

The singleton metaclass for ensuring only one instance of a class.

### Classes

#### `Singleton`

Singleton metaclass for ensuring only one instance of a class.

Example:

```python
from autogpt.singleton import Singleton

singleton = Singleton(...)
```

#### `AbstractSingleton`

Abstract singleton class for ensuring only one instance of a class.

Example:

```python
from autogpt.singleton import AbstractSingleton

abstractSingleton = AbstractSingleton(...)
```

---

## Module: `autogpt.speech.__init__`

This module contains the speech recognition and speech synthesis functions.

---

## Module: `autogpt.speech.base`

Base class for all voice classes.

### Classes

#### `VoiceBase`

Base class for all voice classes.

Example:

```python
from autogpt.speech.base import VoiceBase

voiceBase = VoiceBase(...)
```

##### Methods

- `say(self, text: str, voice_index: int=0)`: Say the given text.

Args:
    text (str): The text to say.
    voice_index (int): The index of the voice to use.

  Example:

```python
voiceBase = VoiceBase(...)
voiceBase.say(...)
```

---

## Module: `autogpt.speech.brian`

No description available.

### Classes

#### `BrianSpeech`

Brian speech module for autogpt

Example:

```python
from autogpt.speech.brian import BrianSpeech

brianSpeech = BrianSpeech(...)
```

---

## Module: `autogpt.speech.eleven_labs`

ElevenLabs speech module

### Classes

#### `ElevenLabsSpeech`

ElevenLabs speech class

Example:

```python
from autogpt.speech.eleven_labs import ElevenLabsSpeech

elevenLabsSpeech = ElevenLabsSpeech(...)
```

---

## Module: `autogpt.speech.gtts`

GTTS Voice. 

### Classes

#### `GTTSVoice`

GTTS Voice.

Example:

```python
from autogpt.speech.gtts import GTTSVoice

gTTSVoice = GTTSVoice(...)
```

---

## Module: `autogpt.speech.macos_tts`

MacOS TTS Voice. 

### Classes

#### `MacOSTTS`

MacOS TTS Voice.

Example:

```python
from autogpt.speech.macos_tts import MacOSTTS

macOSTTS = MacOSTTS(...)
```

---

## Module: `autogpt.speech.say`

Text to speech module 

### Functions

#### `say_text(text: str, voice_index: int=0)`

Speak the given text using the given voice index

Example:

```python
from autogpt.speech.say import say_text

say_text(...)
```

---

## Module: `autogpt.spinner`

A simple spinner module

### Classes

#### `Spinner`

A simple spinner class

Example:

```python
from autogpt.spinner import Spinner

spinner = Spinner(...)
```

##### Methods

- `spin(self)`: Spin the spinner

  Example:

```python
spinner = Spinner(...)
spinner.spin(...)
```

- `update_message(self, new_message, delay=0.1)`: Update the spinner message
Args:
    new_message (str): New message to display.
    delay (float): The delay in seconds between each spinner update.

  Example:

```python
spinner = Spinner(...)
spinner.update_message(...)
```

---

## Module: `autogpt.token_counter`

Functions for counting the number of tokens in a message or string.

### Functions

#### `count_message_tokens(messages: List[Message], model: str='gpt-3.5-turbo-0301')`

Returns the number of tokens used by a list of messages.

Args:
    messages (list): A list of messages, each of which is a dictionary
        containing the role and content of the message.
    model (str): The name of the model to use for tokenization.
        Defaults to "gpt-3.5-turbo-0301".

Returns:
    int: The number of tokens used by the list of messages.

Example:

```python
from autogpt.token_counter import count_message_tokens

count_message_tokens(...)
```

#### `count_string_tokens(string: str, model_name: str)`

Returns the number of tokens in a text string.

Args:
    string (str): The text string.
    model_name (str): The name of the encoding to use. (e.g., "gpt-3.5-turbo")

Returns:
    int: The number of tokens in the text string.

Example:

```python
from autogpt.token_counter import count_string_tokens

count_string_tokens(...)
```

---

## Module: `autogpt.types.openai`

Type helpers for working with the OpenAI library

### Classes

#### `Message`

OpenAI Message object containing a role and the message content

Example:

```python
from autogpt.types.openai import Message

message = Message(...)
```

---

## Module: `autogpt.url_utils.__init__`

No description available.

---

## Module: `autogpt.url_utils.validators`

No description available.

### Functions

#### `validate_url(func: Callable[..., Any])`

The method decorator validate_url is used to validate urls for any command that requires
a url as an arugment

Example:

```python
from autogpt.url_utils.validators import validate_url

validate_url(...)
```

#### `is_valid_url(url: str)`

Check if the URL is valid

Args:
    url (str): The URL to check

Returns:
    bool: True if the URL is valid, False otherwise

Example:

```python
from autogpt.url_utils.validators import is_valid_url

is_valid_url(...)
```

#### `sanitize_url(url: str)`

Sanitize the URL

Args:
    url (str): The URL to sanitize

Returns:
    str: The sanitized URL

Example:

```python
from autogpt.url_utils.validators import sanitize_url

sanitize_url(...)
```

#### `check_local_file_access(url: str)`

Check if the URL is a local file

Args:
    url (str): The URL to check

Returns:
    bool: True if the URL is a local file, False otherwise

Example:

```python
from autogpt.url_utils.validators import check_local_file_access

check_local_file_access(...)
```

---

## Module: `autogpt.utils`

No description available.

### Functions

#### `clean_input(prompt: str='')`

No description available.

Example:

```python
from autogpt.utils import clean_input

clean_input(...)
```

#### `validate_yaml_file(file: str)`

No description available.

Example:

```python
from autogpt.utils import validate_yaml_file

validate_yaml_file(...)
```

#### `readable_file_size(size, decimal_places=2)`

Converts the given size in bytes to a readable format.
Args:
    size: Size in bytes
    decimal_places (int): Number of decimal places to display

Example:

```python
from autogpt.utils import readable_file_size

readable_file_size(...)
```

#### `get_bulletin_from_web()`

No description available.

Example:

```python
from autogpt.utils import get_bulletin_from_web

get_bulletin_from_web(...)
```

#### `get_current_git_branch()`

No description available.

Example:

```python
from autogpt.utils import get_current_git_branch

get_current_git_branch(...)
```

#### `get_latest_bulletin()`

No description available.

Example:

```python
from autogpt.utils import get_latest_bulletin

get_latest_bulletin(...)
```

---

## Module: `autogpt.workspace.__init__`

No description available.

---

## Module: `autogpt.workspace.workspace`

=========
Workspace
=========

The workspace is a directory containing configuration and working files for an AutoGPT
agent.

### Classes

#### `Workspace`

A class that represents a workspace for an AutoGPT agent.

Example:

```python
from autogpt.workspace.workspace import Workspace

workspace = Workspace(...)
```

##### Methods

- `root(self)`: The root directory of the workspace.

  Example:

```python
workspace = Workspace(...)
workspace.root(...)
```

- `restrict_to_workspace(self)`: Whether to restrict generated paths to the workspace.

  Example:

```python
workspace = Workspace(...)
workspace.restrict_to_workspace(...)
```

- `make_workspace(cls, workspace_directory: str | Path, *args, **kwargs)`: Create a workspace directory and return the path to it.

Parameters
----------
workspace_directory
    The path to the workspace directory.

Returns
-------
Path
    The path to the workspace directory.

  Example:

```python
workspace = Workspace(...)
workspace.make_workspace(...)
```

- `get_path(self, relative_path: str | Path)`: Get the full path for an item in the workspace.

Parameters
----------
relative_path
    The relative path to resolve in the workspace.

Returns
-------
Path
    The resolved path relative to the workspace.

  Example:

```python
workspace = Workspace(...)
workspace.get_path(...)
```

---
