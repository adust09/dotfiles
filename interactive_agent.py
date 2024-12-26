from langchain_openai import ChatOpenAI
from browser_use import Agent
import asyncio
import os

api_key = os.getenv("OPENAI_API_KEY")
if api_key:
    print(f"API Key loaded: {api_key}")
else:
    print("Failed to load API Key. Is it set in the environment?")

async def interactive_chat():
    print("Welcome to the interactive flight search tool!")
    print("Type 'exit' to quit.\n")

    while True:
        task = input("Enter your task (e.g., 'Find a one-way flight...'): ").strip()
        if task.lower() == "exit":
            print("Goodbye!")
            break

        agent = Agent(
            task=task,
            llm=ChatOpenAI(model="gpt-4o"),
        )
        print("\nSearching...\n")
        try:
            result = await agent.run()
            print(f"\nResult:\n{result}\n")
        except Exception as e:
            print(f"An error occurred: {e}\n")

if __name__ == "__main__":
    asyncio.run(interactive_chat())
