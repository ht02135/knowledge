select max(len(COALESCE(title,''))) as 'max_length' from population_client with(nolock)
